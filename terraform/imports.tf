# One-off adoption of resources that existed before this repository.
# Delete this file once the first apply has imported everything.

locals {
  imported_email_routing_address_ids = {
    pulsate    = "9064ddceb211435a9a6788343480c7e4"
    m1sk9      = "6c324f6aa8a64ba381769075cbec0eea"
    mikuroxina = "ab3bdfc4ded445b6aec5e82a19a9ba56"
    laminne    = "5d7d5f1f2a0846beb11d0f565daefc16"
  }

  imported_email_routing_rule_ids = {
    info       = "5e666ba273fb4137acd4f7d738751d6c"
    billing    = "c88ac4254514413ebff3f3e9b55e31c0"
    moderator  = "1bfdf42bf7da453882f8d08c56fb54d7"
    m1sk9      = "ee29957826a34efe9e00efeba361792c"
    mikuroxina = "5da8dbbcb4134bffa1f6faf4614d283a"
    laminne    = "81d7c998e90f439bb8782b9d364c531b"
  }
}

import {
  to = cloudflare_dns_record.website
  id = "${local.cloudflare_zone_id}/993d55857e04ca855f38a9276510c2c2"
}

import {
  to = cloudflare_dns_record.spec
  id = "${local.cloudflare_zone_id}/e3f18eb0872ad89cfff4b718fa58dca9"
}

import {
  to = cloudflare_dns_record.demo_a
  id = "${local.cloudflare_zone_id}/d87f8cc45f60cdc8ef7796d82854f204"
}

import {
  to = cloudflare_dns_record.demo_aaaa
  id = "${local.cloudflare_zone_id}/b6ba2b31f6a3fe2666e2de78826649f2"
}

import {
  to = cloudflare_dns_record.spf
  id = "${local.cloudflare_zone_id}/f8ab0dbffabdd1ebba2170aba2c4f7f1"
}

import {
  to = cloudflare_dns_record.dmarc
  id = "${local.cloudflare_zone_id}/70f98e841372c09a00bcf1f67a6a544f"
}

import {
  to = cloudflare_dns_record.atproto
  id = "${local.cloudflare_zone_id}/21abc392e889de1217c5c697acf69cf5"
}

import {
  to = cloudflare_dns_record.github_org_verification
  id = "${local.cloudflare_zone_id}/d1adec5d5781b3fcfc8ae37367d68cda"
}

import {
  to = cloudflare_dns_record.onepassword_verification
  id = "${local.cloudflare_zone_id}/a05a562d2a23e2fca2a161094bbbbc36"
}

import {
  for_each = local.imported_email_routing_address_ids
  to       = cloudflare_email_routing_address.destination[each.key]
  id       = "${local.cloudflare_account_id}/${each.value}"
}

import {
  for_each = local.imported_email_routing_rule_ids
  to       = cloudflare_email_routing_rule.forward[each.key]
  id       = "${local.cloudflare_zone_id}/${each.value}"
}

import {
  to = cloudflare_email_routing_catch_all.this
  id = local.cloudflare_zone_id
}

import {
  to = cloudflare_workers_script.link
  id = "${local.cloudflare_account_id}/link-pulsate-dev"
}

import {
  to = cloudflare_workers_custom_domain.link
  id = "${local.cloudflare_account_id}/75d3f4f7b4010d5a847162242f2a144f494cb930"
}

import {
  to = cloudflare_workers_script_subdomain.link
  id = "${local.cloudflare_account_id}/link-pulsate-dev"
}
