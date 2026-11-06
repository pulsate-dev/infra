# terraform

`pulsate.dev` の Cloudflare リソースを Terraform で管理します．

State は Cloudflare R2 のバケット `pulsate-terraform-state` に置いています (key: `infra/terraform.tfstate`)．ロックは S3 backend の `use_lockfile` を使います．

## 管理対象

| ファイル | 内容 |
|---|---|
| [`cloudflare_dns_record.tf`](./cloudflare_dns_record.tf) | DNS レコード (website，spec，demo，SPF / DMARC，各種ドメイン認証) |
| [`cloudflare_email_routing.tf`](./cloudflare_email_routing.tf) | Email Routing の転送ルール，転送先アドレス，catch-all |
| [`cloudflare_worker.tf`](./cloudflare_worker.tf) | このリポジトリにソースを持つ Worker (`link.pulsate.dev`) とそのカスタムドメイン．スクリプト本体は [`workers/`](./workers) にあります |
| [`imports.tf`](./imports.tf) | 既存リソースの取り込み用．初回の apply 後に削除します |

website，caramel，blog の Worker は各リポジトリの `wrangler.jsonc` から wrangler でデプロイしており，ここでは扱いません．

次のものは Cloudflare 側が作成・ロックするため，Terraform では管理しません．

- Email Routing の MX レコードと DKIM レコード
- Workers のカスタムドメインが作る `100::` の AAAA レコード
- Email Routing の有効化設定 (API トークンで読み取れないため)

## Email Routing

リポジトリが公開されているため，転送先 (メンバー個人のアドレス) はコードに書かず，sensitive な変数 `email_routing_destinations` で渡します．コードには「エイリアス → 持ち主のラベル」の対応だけを書きます (`local.email_routing_forwards`)．

変数の値は「ラベル → 転送先アドレス」の JSON です．

```json
{"pulsate": "...", "m1sk9": "...", "...": "..."}
```

エイリアスを追加・変更する手順は次のとおりです．

1. `cloudflare_email_routing.tf` の `email_routing_forwards` にエイリアスとラベルを追加します．
2. 新しいラベルの場合は，GitHub の secret `EMAIL_ROUTING_DESTINATIONS` (と手元の `mise.local.toml`) にラベルと転送先を追加します．
3. マージ後，新しい転送先アドレスには Cloudflare から確認メールが届きます．持ち主がリンクを踏むまで転送されません．

## 適用

GitHub Actions で自動適用されます．

- **CI** (pull request): `terraform fmt -check`，`tflint`，`terraform validate`，`terraform plan`
- **CD** (`main` への push): `terraform plan`，`terraform apply`

CI は読み取り専用のトークンだけを持ち，`-lock=false` で plan します．書き込み用のトークンは `main` からしか使えない Environment `terraform` にだけ置いています．

### GitHub に登録する secret

| 名前 | 置き場所 | 内容 |
|---|---|---|
| `CLOUDFLARE_API_TOKEN_READ` | Repository secret | Cloudflare API トークン (読み取り専用) |
| `EMAIL_ROUTING_DESTINATIONS` | Repository secret | Email Routing の転送先 (上記の JSON)．CI と CD の両方で使います |
| `R2_STATE_READ_ACCESS_KEY_ID` / `R2_STATE_READ_SECRET_ACCESS_KEY` | Repository secret | state バケットの R2 API トークン (Object Read only) |
| `CLOUDFLARE_API_TOKEN_WRITE` | Environment `terraform` | Cloudflare API トークン (書き込み可) |
| `R2_STATE_WRITE_ACCESS_KEY_ID` / `R2_STATE_WRITE_SECRET_ACCESS_KEY` | Environment `terraform` | state バケットの R2 API トークン (Object Read & Write) |

Environment `terraform` は Deployment branches を `main` のみに制限してください．

Cloudflare API トークンに必要な権限は次のとおりです (読み取り用は Read，書き込み用は Edit)．

- Zone: DNS
- Zone: Email Routing Rules
- Account: Email Routing Addresses
- Account: Workers Scripts

## 初回セットアップ

State バケットは Terraform 自身では管理しません (自分の state を置くバケットを自分で作ることになるため)．最初に一度だけ手作業で用意します．

1. Cloudflare ダッシュボードで R2 バケット `pulsate-terraform-state` を作成します．
2. R2 の API トークンを 2 つ発行します (いずれもこのバケットに限定)．
   - Object Read only: CI 用
   - Object Read & Write: CD 用
3. 上の表のとおり GitHub に secret を登録します．

## 手元での実行

`mise.local.toml` に認証情報を書いてから実行します (このファイルは Git 管理外です)．

```toml
[env]
R2_ACCESS_KEY_ID = "..."
R2_SECRET_ACCESS_KEY = "..."
AWS_ACCESS_KEY_ID = "{{ env.R2_ACCESS_KEY_ID }}"
AWS_SECRET_ACCESS_KEY = "{{ env.R2_SECRET_ACCESS_KEY }}"
TF_VAR_cloudflare_api_token = "..."
TF_VAR_email_routing_destinations = '{"pulsate": "...", "m1sk9": "..."}'
```

S3 backend は認証情報を `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` からしか読まないため，R2 のトークンをこの名前に渡しています．

```fish
cd terraform
terraform init
terraform fmt -check -recursive
tflint
terraform validate
terraform plan -lock=false
```
