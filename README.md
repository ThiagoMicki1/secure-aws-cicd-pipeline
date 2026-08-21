# Secure AWS CI/CD Pipeline

[![CI](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/ci.yml/badge.svg)](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/ci.yml)
[![Security](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/security.yml/badge.svg)](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/security.yml)
[![Terraform Validate](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/ThiagoMicki1/secure-aws-cicd-pipeline/actions/workflows/terraform-validate.yml)

An intermediate DevSecOps portfolio lab that shows how a small web app can be tested, containerized, scanned, and prepared for a future AWS deployment using GitHub Actions, Terraform, and GitHub OIDC.

**This project does not deploy to AWS by default.** The normal workflow is safe portfolio mode: run tests, build Docker, scan code, scan infrastructure, and validate Terraform without AWS credentials.

## Why I Built This

Entry-level cloud security and DevSecOps roles expect more than writing application code. This project demonstrates how to think about secure delivery: least privilege, no long-lived cloud keys, automated security checks, infrastructure-as-code review, and clear deployment guardrails.

## Skills Demonstrated

- Python Flask web app development
- Docker image hardening basics
- GitHub Actions CI/CD design
- SAST with Semgrep
- Secrets detection with Gitleaks
- Container vulnerability scanning with Trivy
- Terraform validation and IaC scanning with Checkov
- AWS IAM least privilege
- GitHub Actions OIDC for future AWS access
- Safe documentation for deployment, cost, and cleanup

## Architecture

```text
Developer
   |
   v
GitHub Repository
   |-- CI Workflow: tests + Docker build
   |-- Security Workflow: Gitleaks + Semgrep + Trivy + Checkov
   |-- Terraform Validate Workflow
   |
   `-- Manual Deploy Workflow, future use only
          |
          v
      AWS IAM OIDC Role
          |
          v
      Amazon ECR -> AWS App Runner -> CloudWatch Logs
```

## Project Structure

```text
secure-aws-cicd-pipeline/
├── app/                         # Simple Flask web app
├── tests/                       # Pytest validation tests
├── infra/terraform/             # AWS App Runner, ECR, IAM OIDC Terraform
├── .github/workflows/           # CI, security, Terraform validate, manual deploy
├── docs/                        # Security and AWS explanations
├── reports/                     # Sanitized sample outputs
├── Dockerfile                   # Hardened app container
├── .dockerignore
├── .gitleaks.toml
├── .checkov.yml
├── .semgrepignore
├── requirements.txt
├── requirements-dev.txt
└── requirements-security.txt
```

## Features

- Safe Flask app with `/`, `/health`, `/ready`, and `/security-controls`
- Docker image runs as a non-root user
- Pinned Python dependencies
- GitHub Actions with least-privilege workflow permissions
- Security workflow for secrets, SAST, IaC, and container scanning
- Terraform workflow that runs `fmt`, `init -backend=false`, and `validate`
- Manual-only future deploy workflow with `workflow_dispatch`
- GitHub OIDC role design instead of long-lived AWS access keys
- Cost and cleanup documentation for optional future AWS use

## Safe Mode vs Optional Deploy Mode

Safe mode is the default and recommended portfolio mode. It requires no AWS account and no AWS credentials. You can run tests, build the image, run scanners, and validate Terraform locally or in GitHub Actions.

Optional deploy mode is future-facing. It requires an AWS account, a configured GitHub OIDC role, repository variables, a pushed ECR image, and a manual workflow run. It is never triggered by push or pull request. See [docs/deployment-bootstrap.md](docs/deployment-bootstrap.md) before attempting any future deployment.

## Run Locally

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements-dev.txt
flask --app app.main run --host 127.0.0.1 --port 8000
```

Open:

```text
http://127.0.0.1:8000
http://127.0.0.1:8000/health
```

## Run Tests

```bash
python -m pytest -q
```

## Build and Run Docker

```bash
docker build -t secure-aws-cicd-pipeline:local .
docker run --rm -p 8000:8000 secure-aws-cicd-pipeline:local
```

## Run Local Security Scans

```bash
gitleaks detect --source . --config .gitleaks.toml
semgrep scan app tests --config semgrep.yml --error --metrics=off --disable-version-check
checkov -d . --config-file .checkov.yml
trivy image --scanners vuln --pkg-types os --severity HIGH,CRITICAL --ignore-unfixed secure-aws-cicd-pipeline:local
```

## Validate Terraform Without Deploying

```bash
cd infra/terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
cd ../..
```

Do not run `terraform apply` unless you intentionally want to create AWS resources.

## Future AWS OIDC Setup

The manual deploy workflow uses GitHub OIDC, not stored AWS access keys. In a future deployment, AWS trusts GitHub's OIDC provider and allows only this repository and branch/environment to assume the deploy role.

Required future GitHub repository variables:

```text
AWS_REGION=us-east-1
AWS_DEPLOY_ROLE_ARN=arn:aws:iam::<account-id>:role/<role-name>
```

Use placeholders in docs only. Do not commit real AWS account IDs or credentials.

## Optional Manual Deployment

The deploy workflow is intentionally manual-only:

```yaml
on:
  workflow_dispatch:
```

It asks for a cost confirmation phrase before running Terraform. This is a guardrail, not a billing guarantee.

## Cost Warning

AWS App Runner, ECR, CloudWatch Logs, and related resources can create AWS costs. This repository is safe by default because validation does not create cloud resources.

## Cleanup If Deployed Later

If you intentionally deploy in the future, destroy resources when finished:

```bash
cd infra/terraform
terraform destroy -var-file="terraform.tfvars"
```

Also check the AWS Console for ECR images, App Runner services, CloudWatch log groups, and IAM roles.

## Sample Output

See:

- `reports/sample-ci-output.txt`
- `reports/sample-security-scan-output.txt`
- `reports/sample-terraform-plan.txt`

## What I Learned

- CI/CD security starts with small workflow permissions.
- OIDC avoids long-lived cloud keys in GitHub secrets.
- Scanners are most useful when their findings are explained and remediated.
- Terraform validation is safe; Terraform apply changes real infrastructure.
- Manual deployment gates reduce accidental cloud risk.

## What I Struggled With

The hardest part was separating safe validation from real deployment. I wanted the repo to look deployment-ready, but I also had to make sure it would not create AWS resources by accident. Understanding why OIDC is safer than storing AWS keys helped the design click: GitHub can request short-lived credentials only when the manual workflow is intentionally run.

## Future Improvements

- Add SARIF upload for scanner results
- Add branch protection rules
- Add a real staging environment after AWS budget alerts are configured
- Add CloudTrail and AWS Config examples
- Add signed container images
- Add Open Policy Agent policy checks
