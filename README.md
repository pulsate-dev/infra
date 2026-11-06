# infra

[![CI](https://github.com/pulsate-dev/infra/actions/workflows/ci.yaml/badge.svg)](https://github.com/pulsate-dev/infra/actions/workflows/ci.yaml)
[![CD](https://github.com/pulsate-dev/infra/actions/workflows/cd.yaml/badge.svg)](https://github.com/pulsate-dev/infra/actions/workflows/cd.yaml)

Managed infrastructure for Pulsate projects.

----

- [`terraform`](./terraform/README.md)
  - `pulsate.dev` の Cloudflare リソース (DNS，Email Routing，Workers) の IaC 管理．
  - `main` へのマージで GitHub Actions が自動適用します．
