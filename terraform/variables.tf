variable "cloudflare_api_token" {
  description = "A Cloudflare API token (read-only in CI, read-write in CD)"
  type        = string
  sensitive   = true
  ephemeral   = true
}
