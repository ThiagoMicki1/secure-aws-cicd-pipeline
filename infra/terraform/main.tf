locals {
  repository_name  = var.project_name
  image_identifier = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
}

resource "aws_ecr_repository" "app" {
  # checkov:skip=CKV_AWS_136:Portfolio lab avoids a billable customer-managed KMS key; use KMS in production.
  name                 = local.repository_name
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the last 10 pushed images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "app" {
  # checkov:skip=CKV_AWS_158:Portfolio lab uses AWS-managed encryption; use customer-managed KMS in production.
  name              = "/aws/apprunner/${var.project_name}"
  retention_in_days = 365
}

resource "aws_apprunner_service" "app" {
  service_name = var.project_name

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = local.image_identifier
      image_repository_type = "ECR"

      image_configuration {
        port = "8000"
        runtime_environment_variables = {
          APP_ENV = "portfolio-lab"
        }
      }
    }
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 3
  }

  depends_on = [aws_cloudwatch_log_group.app]
}
