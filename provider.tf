terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.40.0"
    }
  }
}

# Configuración del proveedor AWS para Terraform

provider "aws" {
  # Región de AWS donde se desplegarán los recursos.
  # Cambia el valor de la región según tu ubicación o requisitos.
  region = "us-east-1"
}