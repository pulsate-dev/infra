# Managed Cloudflare DNS records.
#
# Records Cloudflare creates and locks itself are deliberately absent: the MX and
# DKIM records belong to Email Routing, and the `100::` AAAA records belong to
# Workers custom domains. Managing them here would fight their owners.

# --- Websites ---

# pulsate.dev - website (Cloudflare Pages, until it moves to Workers)
resource "cloudflare_dns_record" "website" {
  zone_id = local.cloudflare_zone_id
  name    = "pulsate.dev"
  content = "website-bas.pages.dev"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "spec" {
  zone_id = local.cloudflare_zone_id
  name    = "spec.pulsate.dev"
  content = "pulsate-dev.github.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
  comment = "Pulsate Specification"
}

# demo.pulsate.dev - Demo instance behind an externally operated proxy
resource "cloudflare_dns_record" "demo_a" {
  zone_id = local.cloudflare_zone_id
  name    = "demo.pulsate.dev"
  content = "133.18.124.103"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "宛先はlaminneが運用しているプロキシです"
}

resource "cloudflare_dns_record" "demo_aaaa" {
  zone_id = local.cloudflare_zone_id
  name    = "demo.pulsate.dev"
  content = "2406:8c00:0:3459:133:18:124:103"
  type    = "AAAA"
  ttl     = 1
  proxied = false
  comment = "宛先はlaminneが運用しているプロキシです"
}

# --- Email ---

# Why SPF lives here while MX does not: Email Routing created this record but
# left it unlocked, so nothing else owns it.
resource "cloudflare_dns_record" "spf" {
  zone_id = local.cloudflare_zone_id
  name    = "pulsate.dev"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  type    = "TXT"
  ttl     = 1
  comment = "Email Routing"
}

# The rua address is where Cloudflare DMARC Management collects reports; changing
# it silently stops the reports in the dashboard.
resource "cloudflare_dns_record" "dmarc" {
  zone_id = local.cloudflare_zone_id
  name    = "_dmarc.pulsate.dev"
  content = "\"v=DMARC1;  p=none; rua=mailto:bddc130355b1479d818ddde2626a0c85@dmarc-reports.cloudflare.net\""
  type    = "TXT"
  ttl     = 1
}

# --- Verification ---

resource "cloudflare_dns_record" "atproto" {
  zone_id = local.cloudflare_zone_id
  name    = "_atproto.pulsate.dev"
  content = "did=did:plc:yjtgrihpepe6izky2hd6athz"
  type    = "TXT"
  ttl     = 1
  comment = "Bluesky Handle"
}

resource "cloudflare_dns_record" "github_org_verification" {
  zone_id = local.cloudflare_zone_id
  name    = "_github-challenge-pulsate-dev-org.pulsate.dev"
  content = "9370347ec4"
  type    = "TXT"
  ttl     = 1
  comment = "GitHub Verified & approved domains"
}

resource "cloudflare_dns_record" "onepassword_verification" {
  zone_id = local.cloudflare_zone_id
  name    = "pulsate.dev"
  content = "1password-site-verification=DIZRHZ2CDZBL5NWYNJ6FWYH4EI"
  type    = "TXT"
  ttl     = 1
  comment = "1Password Domain"
}
