terraform {
  backend "s3" {
    bucket = "tf-juice-shop-state-awscd"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}