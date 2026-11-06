# infra

[![CI](https://github.com/pulsate-dev/infra/actions/workflows/ci.yaml/badge.svg)](https://github.com/pulsate-dev/infra/actions/workflows/ci.yaml)
[![CD](https://github.com/pulsate-dev/infra/actions/workflows/cd.yaml/badge.svg)](https://github.com/pulsate-dev/infra/actions/workflows/cd.yaml)

Managed infrastructure for Pulsate projects.

## 管理しているもの

`pulsate.dev` の Cloudflare リソースを Terraform で管理しています．

- DNS レコード
- Email Routing (`@pulsate.dev` の転送ルール)
- `link.pulsate.dev` の Worker

website，caramel，blog の Worker は各リポジトリから wrangler でデプロイしており，ここでは管理していません．

## 変更の流れ

**`main` へのマージはそのまま本番への適用です．** Cloudflare のダッシュボードから直接変更すると Terraform と食い違うので，必ずこのリポジトリを経由してください．

1. ブランチを切って `terraform/` を変更し，pull request を作成します．
2. CI が `terraform plan` を実行します．ログで意図しない変更・削除がないことを確認します．
3. レビュー後に `main` へマージすると，CD が `terraform apply` を実行します．

## ガイド

- **DNS レコードを追加する**: [`terraform/cloudflare_dns_record.tf`](./terraform/cloudflare_dns_record.tf) に `cloudflare_dns_record` を追加します．
- **メールアドレス (`<名前>@pulsate.dev`) を追加する**: 転送先は個人のアドレスなのでコードには書きません．手順は [`terraform/README.md`](./terraform/README.md#email-routing) を参照してください．

セットアップ手順や GitHub の secret については [`terraform/README.md`](./terraform/README.md) にまとめています．
