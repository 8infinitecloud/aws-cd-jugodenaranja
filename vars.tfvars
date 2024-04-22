#############################################################
# VARIABLES MAIN: HS-JUICE-SHOP
#############################################################
#!!! OBLIGATIORIO EDITAR !!!
# Asigna los availability zones disponibles en tu REGION que configuraste en provider.tf

availability_zone1a = ""
# availability_zone1a: nombre de la primera zona de disponibilidad. Ejemplo: "us-west-2a"

availability_zone1b = ""
# availability_zone1b: nombre de la segunda zona de disponibilidad. Ejemplo: "us-west-2b"

#############################################################
# VARIABLES MAIN: HS-JUICE-SHOP
#############################################################
#!!! OPCIONAL !!!
#EXISTEN VALORES POR DEFECTO EN EL ARCHIVO, SI TIENES QUE
#PERSONALIZAR ALGUNOS DE ELLOS LO PUEDES REALIZAR DESDE AQUI

vpc = ""
# vpc: nombre de la VPC. Ejemplo: "mi-vpc"

subnetpublica1 = ""
# subnetpublica1: nombre de la primera subred pública. Ejemplo: "subnet-publica-1"

subnetpublica2 = ""
# subnetpublica2: nombre de la segunda subred pública. Ejemplo: "subnet-publica-2"

subnetprivate1 = ""
# subnetprivate1: nombre de la primera subred privada. Ejemplo: "subnet-privada-1"

subnetprivate2 = ""
# subnetprivate2: nombre de la segunda subred privada. Ejemplo: "subnet-privada-2"

repository = ""
# repository: repositorio donde se encuentra nuestra aplicación "Juice Shop"