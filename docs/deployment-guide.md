# Deployment Guide

This repository is safe by default. Deployment is optional and manual-only.

## Safe Portfolio Mode

Use this mode for GitHub and interviews:

```bash
pytest -q
docker build -t secure-aws-cicd-pipeline:local .
cd infra/terraform
terraform init -backend=false
terraform validate
```

This mode does not create AWS resources.

## Optional Future Deploy Mode

Only use this mode if you intentionally want to create AWS resources.

Requirements:

- AWS account
- Terraform installed
- AWS budget alerts configured
- GitHub repository variable `AWS_REGION`
- GitHub repository variable `AWS_DEPLOY_ROLE_ARN`
- `infra/terraform/terraform.tfvars` created locally from the example file

## Manual Workflow Guardrails

The deploy workflow:

- Runs only with `workflow_dispatch`
- Requires a cost confirmation phrase
- Uses GitHub OIDC
- Does not use long-lived AWS keys
- Does not run on push
- Does not run on pull request

## Destroy

If resources are deployed later, clean them up:

```bash
cd infra/terraform
terraform destroy -var-file="terraform.tfvars"
```

Then check AWS manually for leftover ECR images, App Runner services, CloudWatch log groups, and IAM roles.
