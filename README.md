# _Jugo de naranja con CodePipeline y Elastic Beanstalk_

## _Descripción_

El objetivo de este proyecto es implementar un flujo CI/CD (Integración Continua / Entrega Continua) utilizando GitHub Actions, Terraform y AWS para desplegar la aplicación Juice Shop de OWASP. Juice Shop es una aplicación web de referencia de código abierto para probar y mejorar las habilidades de hacking y seguridad en aplicaciones web.

## _Objetivos_

- Configurar un flujo de trabajo de CI/CD utilizando GitHub Actions para automatizar la construcción, pruebas y despliegue de la aplicación Juice Shop.
- Utilizar Terraform para definir la infraestructura necesaria en AWS para desplegar la aplicación.
- Desplegar automáticamente la aplicación en AWS después de que se realicen cambios en el repositorio de infraestructura o aplicación.

## _Pasos del Proyecto_

1. **Pre-requisito de configuraciones de GitHub**: Realizar un fork o clon de este repositorio y configurar un repositorio en GitHub para el proyecto Juice Shop.

2. **Pre-requesito y estructura del terraform en el Repositorio**: Realizar las configuraciones necesarias de acuerdo al ambiente personal en AWS que tenga para el despliegue de los recursos con terraform.

3. **Estructura del GitHub Actions en el Repositorio**: Entender el flujo de trabajo de GitHub Actions para automatizar la construcción, pruebas y despliegue de la infraestructura.

## _Resultados Esperados_

Con este proyecto, se espera comprender y practicar el proceso completo de un pipeline CI/CD, desde el código hasta el despliegue de una aplicación, utilizando herramientas modernas como GitHub Actions, Terraform y AWS.

## _Indicaciones:_

## Pre-requisito de configuraciones de GitHub

### Credenciales AWS
Las credenciales de AWS (AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY) se almacenan como secretos en la configuración del repositorio de GitHub. Estos secretos se utilizan en los flujos de trabajo de GitHub Actions para autenticar y autorizar las operaciones de Terraform en AWS. Al utilizar secretos, se mantiene la seguridad de las credenciales y se evita exponerlas en texto plano en los archivos de configuración.

#### Configuración de Credenciales

Las credenciales de AWS se manejan como secretos de entorno en GitHub Actions para mantenerlas seguras. Sigue estos pasos para configurar las credenciales como secretos de entorno:

1. En tu repositorio de GitHub, ve a la pestaña "Configuración" (Settings).
2. En el menú de la izquierda, haz clic en "Secretos" (Secrets).
3. Haz clic en "Nuevo secreto" (New secret).
4. En "Nombre del secreto" (Secret name), introduce `AWS_ACCESS_KEY_ID`.
5. En "Valor del secreto" (Secret value), introduce tu ID de clave de acceso de AWS.
6. Haz clic en "Agregar secreto" (Add secret) para guardar el secreto.
7. Repite los pasos 3-6 para crear otro secreto llamado `AWS_SECRET_ACCESS_KEY` y añadir tu clave de acceso secreta de AWS como valor.
8. Estos secretos se utilizarán automáticamente en GitHub Actions para autenticar con AWS al ejecutar Terraform.

### Protección de la Rama `main`
La protección de la rama `main` está configurada para requerir un pull request antes de fusionar cualquier cambio en esta rama. Esto ayuda a garantizar que los cambios en la infraestructura pasen por una revisión y aprobación adecuadas antes de ser desplegados, lo que reduce el riesgo de errores o cambios no deseados.

#### Configuración para proteccion de la rama `main`

1. **Accede al Repositorio:** Ve al repositorio en GitHub que deseas proteger.

2. **Selecciona la Configuración del Repositorio:** En la parte superior del repositorio, haz clic en la pestaña "Settings" (Configuración).

3. **Selecciona Branches:** En el menú de la izquierda, haz clic en "Branches" (Ramas).

4. **Elige la Rama a Proteger:** En la sección "Branch protection rules" (Reglas de protección de ramas), selecciona la rama `main` o la rama principal de tu repositorio.

5. **Habilita la Protección:** Marca la opción "Protect this branch" (Proteger esta rama).

6. **Configura las Reglas de Protección:** Aquí puedes configurar varias reglas de protección. Algunas de las más comunes son:
   - **Require pull request reviews before merging:** (Requerir revisiones de pull request antes de la fusión) Esto obligará a que todos los cambios sean revisados antes de fusionarse en la rama `main`. 
   - **Require status checks to pass before merging:** (Requerir que los checks de estado pasen antes de fusionar) Puedes especificar ciertos checks de estado que deben pasar antes de que se permita la fusión.

7. **Guarda los Cambios:** Después de configurar las reglas de protección según tus preferencias, haz clic en el botón "Save changes" (Guardar cambios) para aplicar la protección a la rama `main`.

## Pre-requesito y estructura del terraform en el Repositorio

- `backend.tf`: Contiene la configuración del backend de Terraform, como el almacenamiento remoto del estado en un proveedor específico, como S3.
    IMPORTANTE: Existen variables a nivel de terraform que son importantes configurar para tu entorno, en este archivo estan los comentarios que te indicaran cuales son indispensables de modificar y otras opcionales.
- `hs-juice-shop.tf`: Incluye el código de Terraform para definir la infraestructura de red, Elastic Beanstalk y el pipeline de CodePipeline para el proyecto Juice Shop.
- `provider.tf`: Define el proveedor de Terraform utilizado en este proyecto, que en este caso es AWS.
- `vars.tf`: Define las variables de Terraform utilizadas en el proyecto.
    IMPORTANTE: Existen variables a nivel de terraform que son importantes configurar para tu entorno, en este archivo estan los comentarios que te indicaran cuales son indispensables de modificar y otras opcionales.

## Estructura del GitHub Actions en el Repositorio

Este es el flujo de trabajo realizado con GitHub Actions para el proceso de gestión de la infraestructura utilizando Terraform dentro de tu proyecto en GitHub.

### `action-tf-plan.yaml`

Este archivo de flujo de trabajo, "Pull Request Validation", se activa en cada pull request y se encarga de validar y planificar los cambios de Terraform. Realiza las siguientes acciones:
- **Validación de Terraform**: Ejecuta `terraform validate` para verificar la sintaxis y la configuración de los archivos de Terraform.
- **Planificación de Terraform**: Ejecuta `terraform plan` para generar un plan de los cambios propuestos.
- **Validación del plan**: Revisa el plan de Terraform para garantizar que los cambios sean correctos y no introduzcan errores en la infraestructura existente.
- **Notificación de resultado**: Si el plan es correcto, el flujo de trabajo pasa y el pull request puede ser considerado para ser mergeado. Si se detectan errores, el flujo de trabajo falla y se debe revisar los cambios antes de continuar.

### `action-tf-deploy.yaml`

Este archivo de flujo de trabajo, "Deployment on Main Branch", se activa en cada push a la rama `main` y se encarga de aplicar los cambios de Terraform. Realiza las siguientes acciones:
- **Inicialización de Terraform**: Ejecuta `terraform init` para inicializar el directorio de trabajo de Terraform.
- **Planificación de Terraform**: Ejecuta `terraform plan` para generar un plan de los cambios propuestos.
- **Aplicación de cambios**: Ejecuta `terraform apply` para aplicar los cambios de Terraform de manera automática y sin interacción.
- **Notificación de resultado**: Proporciona información sobre el éxito o el fallo de la aplicación de los cambios de Terraform.

### `action-tf-destroy.yaml`

Este archivo de flujo de trabajo, "Destroy Infrastructure", se activa manualmente y se encarga de destruir la infraestructura utilizando Terraform. Realiza las siguientes acciones:
- **Inicialización de Terraform**: Ejecuta `terraform init` para inicializar el directorio de trabajo de Terraform.
- **Destrucicón de la infraestructura**: Ejecuta `terraform destroy` para destruir todos los recursos de la infraestructura gestionada por Terraform.
- **Notificación de resultado**: Proporciona información sobre el éxito o el fallo de la destrucción de la infraestructura.

### <span style="color:red">Advertencia de costos sobre el despliegue de Infraestructura en AWS </span>

Este repositorio contiene código Terraform para desplegar una infraestructura en AWS que incluye una VPC, subredes públicas y privadas, un NAT Gateway, Elastic Beanstalk para despliegue de aplicaciones, y un pipeline de CodePipeline para automatizar el despliegue de la aplicación en Elastic Beanstalk. Una vez terminada la practica eliminar los recursos y desplegarlos nuevamente cuando se proponga un nuevo objetivo o continue con el que estaba revisando.

## _Donde esta la aplicación?_

En las configuraciones de codepipeline definimos cual es el repositorio que utilizaremos para realizar el depsliegue de la aplicacion en Elastic Beanstalk, la utilizada se encuentra definida con la variable `repository` en vars.tf o la puedes cambiar por tu propio fork u otra aplicacion en nodejs 20 en vars.tfvars.