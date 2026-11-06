locals {
  # AccountID and ZoneID are not secret and can be hard-coded.
  # https://github.com/cloudflare/wrangler-legacy/issues/209#issuecomment-541654484
  cloudflare_account_id = "a32537519c6d0040d9f7342e144281ed"
  cloudflare_zone_id    = "c80f0a8995f80d7e1b42928b21c4b405"
}
