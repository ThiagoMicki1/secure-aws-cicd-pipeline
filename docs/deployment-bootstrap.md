# Deployment Bootstrap

This repository is safe by default. The normal portfolio workflow runs tests, Docker builds, security scans, and Terraform validation only.

The manual AWS deployment path is intentionally future-facing. It is not plug-and-play until a few bootstrap steps are completed in a real AWS account.

## OIDC Role Must Exist First

The manual deploy workflow uses GitHub Actions OIDC instead of long-lived AWS keys.

That means AWS must already have:

- a GitHub Actions OIDC identity provider
- an IAM role that trusts this repository
- least-privilege permissions for the specific deployment resources

GitHub Actions cannot assume a role that does not exist yet. The role ARN must be added as the repository variable `AWS_DEPLOY_ROLE_ARN` before the manual deploy workflow can authenticate to AWS.

## `terraform.tfvars` Is Local Only

`infra/terraform/terraform.tfvars.example` is safe to commit because it contains placeholders.

For a real deployment, create a local file:

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
```

Then replace placeholders with real values. The `terraform.tfvars` file is gitignored because it may contain account-specific deployment settings.

## ECR Image Must Exist Before App Runner Uses It

The Terraform App Runner resource points at an ECR image tag. App Runner cannot start from an image that has not been pushed yet.

Before a future App Runner deployment, the container image must be:

1. built locally or in CI
2. authenticated to Amazon ECR
3. pushed to the Terraform-managed ECR repository
4. tagged with the same value used by `image_tag`

## Safe Order for Future Use

1. Enable AWS budget alerts.
2. Review Terraform with `terraform plan`.
3. Bootstrap the OIDC role and repository variables.
4. Build and push the Docker image to ECR.
5. Run the manual deploy workflow only when you intend to create AWS resources.
6. Run `terraform destroy` when finished.

Do not run `terraform apply` casually. AWS App Runner, ECR, CloudWatch Logs, and related resources can create costs.
