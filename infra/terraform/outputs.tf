output "ecr_repository_url" {
  description = "ECR repository URL for the app container image."
  value       = aws_ecr_repository.app.repository_url
}

output "app_runner_service_url" {
  description = "Future App Runner service URL after manual deployment."
  value       = aws_apprunner_service.app.service_url
}

output "github_actions_deploy_role_arn" {
  description = "IAM role ARN to store as the AWS_DEPLOY_ROLE_ARN GitHub repository variable."
  value       = aws_iam_role.github_actions_deploy.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group used by the portfolio lab."
  value       = aws_cloudwatch_log_group.app.name
}
