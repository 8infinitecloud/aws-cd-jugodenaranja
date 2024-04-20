terraform {
  backend "s3" {
    bucket = "tf-juice-shop-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}