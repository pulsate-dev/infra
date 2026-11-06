# Cloudflare Workers
#
# Only Workers whose whole source lives in this repository are managed here.
# Application Workers (website, caramel, blog) are deployed by wrangler from
# their own repositories, which own the script and its routes via wrangler.jsonc.

# link.pulsate.dev - Short links to the project's communities
#
# Why the script name keeps the old `link-pulsate-dev`: the existing script is
# imported rather than recreated, so the custom domain never points at a missing
# script during the cutover from the link.pulsate.dev repository.
resource "cloudflare_workers_script" "link" {
  account_id         = local.cloudflare_account_id
  script_name        = "link-pulsate-dev"
  content_file       = "${path.module}/workers/link.js"
  content_sha256     = filesha256("${path.module}/workers/link.js")
  main_module        = "link.js"
  compatibility_date = "2026-09-21"
}

resource "cloudflare_workers_custom_domain" "link" {
  account_id = local.cloudflare_account_id
  zone_id    = local.cloudflare_zone_id
  hostname   = "link.pulsate.dev"
  service    = cloudflare_workers_script.link.script_name
}

# Custom domain only — disable the workers.dev subdomain exposure.
resource "cloudflare_workers_script_subdomain" "link" {
  account_id       = local.cloudflare_account_id
  script_name      = cloudflare_workers_script.link.script_name
  enabled          = false
  previews_enabled = false
}
