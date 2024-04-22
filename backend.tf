terraform {
  backend "s3" {
    bucket = var.bucket
    key    = var.tfstate
    region = var.region
  }
}