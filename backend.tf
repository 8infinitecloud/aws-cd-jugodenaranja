terraform {
  # Configuración del backend de Terraform para almacenar el estado remoto en S3

  backend "s3" {
    # Nombre del bucket de S3 donde se almacenará el archivo tfstate.
    # Cambia el valor a tu propio bucket de S3.
    bucket = "tf-juice-shop-state-awscd"

    # Nombre del archivo tfstate dentro del bucket de S3.
    # Puedes cambiar el valor si deseas un nombre diferente para el archivo tfstate.
    key    = "terraform.tfstate"

    # Región de AWS donde se encuentra el bucket de S3.
    # Asegúrate de seleccionar la región correcta para tu bucket de S3.
    region = "us-east-1"
  }
}