#############################################################
# NETWORKING
#############################################################

# Define la VPC
resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
}

# Define las subredes públicas
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "us-east-1b"
}

# Define las subredes privadas
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.4.0/24"
  availability_zone = "us-east-1b"
}

# Crea la tabla de rutas para las subredes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }
}

# Crea la tabla de rutas para las subredes privadas
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }
}

# Asocia las subredes públicas con la tabla de rutas pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Asocia las subredes privadas con la tabla de rutas privadas
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

# Define el Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Define el NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  depends_on = [aws_internet_gateway.main]
}

# Define la IP Elastica para el NAT Gateway
resource "aws_eip" "nat" {
  domain   = "vpc"

  depends_on = [aws_internet_gateway.main]
}
#############################################################
# Elastic Beanstalk
#############################################################

#resource "aws_s3_bucket" "s3-juice-shop-workshop" {
#  bucket = "juice-shop-workshop"
#}

# Define la aplicación Elastic Beanstalk
resource "aws_elastic_beanstalk_application" "app_juice_shop" {
  name = "juice-shop-nodejs-app"
}

# Define la versión de la aplicación Elastic Beanstalk
#resource "aws_elastic_beanstalk_application_version" "app_juice_shop_version" {
#  application = aws_elastic_beanstalk_application.app_juice_shop.name
#  name        = "my-app-version"
#  description = "My Node.js application version"
#  bucket = "aws_s3_bucket.s3-juice-shop-workshop"
#  key    = "my-bucket/to/your/app.zip"
#}

# Define el entorno de despliegue Elastic Beanstalk
resource "aws_elastic_beanstalk_environment" "environment_app_juice_shop" {
  name                = "env-juice-shop-workshop"
  application         = aws_elastic_beanstalk_application.app_juice_shop.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.2 running Node.js 20"
  tier                = "WebServer"

  # Configuración de networking
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.private1.id},${aws_subnet.private2.id}" # Las subredes privadas donde deseas desplegar las instancias EC2
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  # Configuración del balanceador de carga
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${aws_subnet.public1.id},${aws_subnet.public2.id}"
  }
  # Configuración de la versión de la aplicación
  #setting {
  #  namespace = "aws:elasticbeanstalk:application"
  #  name      = "ApplicationVersion"
  #  value     = aws_elastic_beanstalk_application_version.app_juice_shop_version.name
  #}
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.medium"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 2
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  depends_on = [
    aws_vpc.main,
    aws_nat_gateway.main
  ]
  # Especifica la configuración adicional según sea necesario, como variables de entorno, configuración de red, etc.
}
#############################################################
# AWS CodePipeline
#############################################################

# Define el pipeline de CodePipeline

resource "random_id" "app_suffix" {
  byte_length = 4  # Longitud del identificador único (en bytes) que deseas generar
}

variable "cicd" {
  type        = string
  default     = "true"
}

resource "aws_codepipeline" "pipeline-juice-shop-ci-cd" {
  count = var.cicd != "true" ? 1 : 0
  name     = "pipeline-juice-shop-ci-cd"
  role_arn = aws_iam_role.codepipeline_role_juice_shop.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.gh-juice-shop.arn
        FullRepositoryId = "8infinitecloud/juice-shop"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "DeployAction"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ElasticBeanstalk"
      input_artifacts  = ["source_output"]
      version          = "1"

      configuration = {
        ApplicationName          = aws_elastic_beanstalk_application.app_juice_shop.name
        EnvironmentName          = aws_elastic_beanstalk_environment.environment_app_juice_shop.name
#        IgnoreApplicationStopFailures = "false"
#        VersionLabel             = "AppVersion_${random_id.app_suffix.hex}"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "gh-juice-shop" {
  name          = "gh-juice-shop-connection"
  provider_type = "GitHub"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role_juice_shop" {
  name               = "codepipeline_role_juice_shop"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
      "cloudformation:*",
      "ec2:*",
      "elasticbeanstalk:*",
      "autoscaling:*",
      "elasticloadbalancing:*"    
    ]

    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.gh-juice-shop.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role_juice_shop.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

# Define el bucket S3 para almacenar los artefactos del pipeline
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "pipeline-gh-artifacts-juice-shop"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}