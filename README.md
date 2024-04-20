# Despliegue de Infraestructura AWS

Este repositorio contiene código Terraform para desplegar una infraestructura en AWS que incluye una VPC, subredes públicas y privadas, un NAT Gateway, Elastic Beanstalk para despliegue de aplicaciones, y un pipeline de CodePipeline para automatizar el despliegue de la aplicación en Elastic Beanstalk.

## Estructura del Repositorio

- `backend.tf`: Define la configuración del backend de Terraform, como el almacenamiento remoto de estado.
- `hs-juice-shop.tf`: Contiene el código Terraform para definir la infraestructura de red, Elastic Beanstalk y el pipeline de CodePipeline.
- `provider.tf`: Define el proveedor de Terraform, en este caso, AWS.
- `README.md`: Este archivo.

## Configuración de Credenciales

Las credenciales de AWS se manejan como secretos de entorno en GitHub Actions para mantenerlas seguras. Sigue estos pasos para configurar las credenciales como secretos de entorno:

1. En tu repositorio de GitHub, ve a la pestaña "Configuración" (Settings).
2. En el menú de la izquierda, haz clic en "Secretos" (Secrets).
3. Haz clic en "Nuevo secreto" (New secret).
4. En "Nombre del secreto" (Secret name), introduce `AWS_ACCESS_KEY_ID`.
5. En "Valor del secreto" (Secret value), introduce tu ID de clave de acceso de AWS.
6. Haz clic en "Agregar secreto" (Add secret) para guardar el secreto.
7. Repite los pasos 3-6 para crear otro secreto llamado `AWS_SECRET_ACCESS_KEY` y añadir tu clave de acceso secreta de AWS como valor.
8. Estos secretos se utilizarán automáticamente en GitHub Actions para autenticar con AWS al ejecutar Terraform.

## Despliegue

Para desplegar la infraestructura, asegúrate de tener Terraform instalado y configurado con tus credenciales de AWS. Luego, ejecuta los siguientes comandos:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan

## Limpieza

Recuerda realizar la limpieza de los recursos creados después de finalizar tus pruebas o trabajos con AWS para evitar incurrir en cargos no deseados. Puedes hacerlo ejecutando los siguientes comandos:

```bash
terraform destroy
```

Este comando eliminará todos los recursos definidos en tu configuración de Terraform. Antes de confirmar la eliminación, revisa cuidadosamente la lista de recursos que se eliminarán.


