terraform {
  # Why R2 rather than HCP Terraform: the project wants CI/CD to live entirely in
  # GitHub, and committing state to this public repository is not an option
  # because state holds Email Routing destination addresses in plain text.
  #
  # The bucket and its R2 API token are created by hand (see README.md): a bucket
  # holding its own state would be a chicken-and-egg problem. Credentials come
  # from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY.
  backend "s3" {
    bucket = "pulsate-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "auto"
    endpoints = {
      s3 = "https://a32537519c6d0040d9f7342e144281ed.r2.cloudflarestorage.com"
    }

    # R2 implements conditional PutObject (If-None-Match), which is what the S3
    # backend's native lock file relies on, so no DynamoDB table is needed.
    use_lockfile = true

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }

  required_version = ">= 1.12.1"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.28.1"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
