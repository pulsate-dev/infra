variable "cloudflare_api_token" {
  description = "A Cloudflare API token (read-only in CI, read-write in CD)"
  type        = string
  sensitive   = true
  ephemeral   = true
}

# Not ephemeral: the addresses are stored attributes of Email Routing resources,
# and ephemeral values cannot flow into state.
variable "email_routing_destinations" {
  description = "Email Routing forwarding destination per owner label, e.g. {\"m1sk9\" = \"...\"}"
  type        = map(string)
  sensitive   = true
}
