# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

The documentation for this repository is generally written in Japanese. Comments and CLAUDE.md are written in English.

## Overview

IaC for the Pulsate project's Cloudflare resources (`pulsate.dev`: DNS, Email Routing, Workers whose source lives here). Modeled on m1sk9/infra, except that state lives in Cloudflare R2 instead of HCP Terraform.

**Merging to `main` is a production deploy** — CD runs `terraform apply`.

## Ownership boundary

- Terraform owns DNS records, Email Routing, and Workers whose source is in `terraform/workers/`.
- Application Workers (website, caramel, blog) are deployed by wrangler from their own repositories; their `wrangler.jsonc` owns the script and its `routes`. Do not add `cloudflare_workers_script` / route resources for them here.
- Cloudflare-locked records (Email Routing MX and DKIM, the `100::` AAAA records of Workers custom domains) and the Email Routing settings are not managed at all.
- Email Routing destinations are members' personal addresses and this repository is public: never write them in code. They come from the sensitive `email_routing_destinations` variable (GitHub secret `EMAIL_ROUTING_DESTINATIONS`); code only maps alias → owner label.

## Documentation

`README.md` and `terraform/README.md` are written in Japanese; keep them in sync with every change (managed resources, required secrets, procedures). Japanese notation: `，` and `．` for punctuation; half-width parentheses with a space before `(` after text.

## Commands

Run in `terraform/` (tool versions are pinned in `mise.toml`):

```sh
terraform fmt -check -recursive
tflint
terraform init && terraform validate
terraform plan -input=false -lock=false
```

## Conventions

- Flat root module, one file per resource family. Cloudflare account/zone IDs are hard-coded in `main.tf` locals (not secrets).
- Comments explain constraints and rejected alternatives ("why not"), in English.
- CI holds read-only credentials only; write credentials live in the `terraform` environment restricted to `main`.
- Required status checks on `main` are pinned to CI job names (`terraform-plan`). Renaming a job requires updating the ruleset.
