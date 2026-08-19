# AWS OIDC Setup

GitHub Actions OIDC lets a workflow request short-lived AWS credentials without storing long-lived AWS access keys in GitHub.

## How It Works

1. AWS has an IAM OIDC identity provider for `https://token.actions.githubusercontent.com`.
2. GitHub Actions requests an OIDC token during a workflow run.
3. AWS validates the token audience and subject.
4. AWS allows the workflow to assume a specific IAM role.
5. The workflow receives temporary credentials for that run only.

## Trust Policy Scope

The Terraform trust policy limits access to:

- One GitHub owner
- One repository
- One branch
- One GitHub Environment name
- The AWS STS audience

That scope is more secure than allowing every repository in an account to assume the role.

## Future Manual Setup

Before real deployment:

1. Copy `infra/terraform/terraform.tfvars.example` to `terraform.tfvars`.
2. Replace placeholders with your GitHub owner and repository name.
3. Verify the current GitHub OIDC thumbprint.
4. Run `terraform plan`.
5. Review the planned IAM permissions.
6. Apply only when you intentionally want AWS resources created.
7. Store the created role ARN as the GitHub repository variable `AWS_DEPLOY_ROLE_ARN`.

Do not store AWS access keys in GitHub secrets for this project.
