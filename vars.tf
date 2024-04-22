#############################################################
# VARIABLES MAIN: HS-JUICE-SHOP
#############################################################

variable "vpc" {
# vpc: CIDR de la VPC. Ejemplo: "10.10.0.0/23"
  type = string
  default = "10.10.0.0/23"
}

variable "subnetpublica1" {
# subnetpublica1: nombre de la primera subred pública. Ejemplo: "subnet-publica-1"
  type = string
  default = "10.10.0.0/24"
}

variable "subnetpublica2" {
# subnetpublica1: nombre de la primera subred pública. Ejemplo: "subnet-publica-2"
  type = string
  default = "10.10.1.0/24"
}

variable "subnetprivate1" {
# subnetprivate1: nombre de la primera subred privada. Ejemplo: "subnet-privada-1"
  type = string
  default = "10.10.2.0/24"
}

variable "subnetprivate2" {
# subnetprivate1: nombre de la primera subred privada. Ejemplo: "subnet-privada-2"
  type = string
  default = "10.10.3.0/24"
}

variable "availability_zone1a" {
# availability_zone1a: nombre de la primera zona de disponibilidad. Ejemplo: "us-west-2a"
  type = string
  default = "us-east-1a"
}

variable "availability_zone1b" {
# availability_zone1b: nombre de la segunda zona de disponibilidad. Ejemplo: "us-west-2b"
  type = string
  default = "us-east-1b"
}

variable "repository" {
# repository: repositorio donde se encuentra nuestra aplicación "Juice Shop"
  type = string
  default = "8infinitecloud/juice-shop"
}