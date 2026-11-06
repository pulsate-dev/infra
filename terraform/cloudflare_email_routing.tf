# Cloudflare Email Routing
#
# Why the destinations are a sensitive variable instead of literals: they are
# members' personal addresses, and both this repository and its Actions logs are
# public. The code only names an owner label per alias; the label-to-address map
# comes from var.email_routing_destinations.
#
# Why the Email Routing settings and its DNS records are not managed: the API
# rejects reading them with the token permissions its own documentation lists,
# and they hold nothing but the on/off switch and Cloudflare-locked MX/DKIM.

locals {
  # <alias>@pulsate.dev => owner label in var.email_routing_destinations
  email_routing_forwards = {
    info       = "pulsate"
    moderator  = "pulsate"
    m1sk9      = "m1sk9"
    mikuroxina = "mikuroxina"
    laminne    = "laminne"
  }
}

# A newly created address only becomes usable after its owner clicks the
# verification mail Cloudflare sends.
resource "cloudflare_email_routing_address" "destination" {
  for_each = toset(values(local.email_routing_forwards))

  account_id = local.cloudflare_account_id
  email      = var.email_routing_destinations[each.key]
}

resource "cloudflare_email_routing_rule" "forward" {
  for_each = local.email_routing_forwards

  zone_id = local.cloudflare_zone_id
  name    = "Forward ${each.key}@pulsate.dev"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = "${each.key}@pulsate.dev"
  }]

  actions = [{
    type  = "forward"
    value = [cloudflare_email_routing_address.destination[each.value].email]
  }]
}

resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = local.cloudflare_zone_id
  enabled = false

  matchers = [{
    type = "all"
  }]

  actions = [{
    type = "drop"
  }]
}
