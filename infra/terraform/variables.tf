variable "project_name" {
  description = "Name prefix for AWS resources."
  type        = string
  default     = "secure-aws-cicd-pipeline"
}

variable "aws_region" {
  description = "AWS region for optional future deployment."
  type        = string
  default     = "us-east-1"
}

variable "github_owner" {
  description = "GitHub username or organization allowed to assume the deploy role."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the deploy role."
  type        = string
  default     = "secure-aws-cicd-pipeline"
}

variable "github_branch" {
  description = "Branch allowed to assume the deploy role."
  type        = string
  default     = "main"
}

variable "github_environment" {
  description = "GitHub Environment name used by the manual deploy workflow."
  type        = string
  default     = "future-aws-deploy"
}

variable "github_oidc_thumbprints" {
  description = "Thumbprints for GitHub Actions OIDC provider. Verify before real deployment."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "image_tag" {
  description = "Container image tag App Runner would use after a future ECR push."
  type        = string
  default     = "manual-demo"
}
