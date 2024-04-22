#############################################################
# VARIABLES BACKEND AND PROVIDER
#############################################################

variable "bucket" {
  type = string
  default = "tf-juice-shop-state-awscd"
}

variable "tfstate" {
  type = string
  default = "terraform.tfstate"
}

variable "region" {
  type = string
  default = "us-east-1"
}

#############################################################
# VARIABLES MAIN: HS-JUICE-SHOP
#############################################################

variable "vpc" {
  type = string
  default = "10.10.0.0/23"
}

variable "subnetpublica1" {
  type = string
  default = "10.10.0.0/24"
}

variable "subnetpublica2" {
  type = string
  default = "10.10.1.0/24"
}

variable "subnetprivate1" {
  type = string
  default = "10.10.2.0/24"
}

variable "subnetprivate2" {
  type = string
  default = "10.10.3.0/24"
}

variable "availability_zone1a" {
  type = string
  default = "us-east-1a"
}

variable "availability_zone1b" {
  type = string
  default = "us-east-1b"
}