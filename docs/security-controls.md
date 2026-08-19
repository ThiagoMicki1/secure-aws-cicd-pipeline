# Security Controls

This project is a safe learning lab for secure CI/CD. The controls below run without AWS credentials.

## Gitleaks

Gitleaks searches the repository for committed secrets such as tokens, private keys, and cloud credentials.

Security meaning: leaked credentials can let an attacker access cloud accounts, CI/CD systems, or private services. This project uses fake placeholders only.

## Semgrep

Semgrep performs static application security testing against the Python Flask app.

Security meaning: SAST can catch risky code patterns before the app is built or deployed.

This lab uses a local `semgrep.yml` so the scan is explainable and does not depend on downloading remote rule packs during a demo.

## Trivy

Trivy scans the Docker image for operating system package vulnerabilities.

Security meaning: containers inherit risk from their base image and installed packages. The workflow fails on HIGH and CRITICAL fixed vulnerabilities.

This lab gates on operating system package vulnerabilities in the container. Python dependency updates are covered separately by Dependabot and pull request review.

## Checkov

Checkov scans Terraform, Dockerfile, and GitHub Actions configuration.

Security meaning: IaC scanning catches risky cloud or pipeline configuration before infrastructure is created.

Accepted lab exceptions:

- `CKV_AWS_136`: ECR uses AWS-managed AES256 encryption to avoid adding a billable customer-managed KMS key in this portfolio lab.
- `CKV_AWS_158`: CloudWatch uses AWS-managed encryption; production systems should use customer-managed KMS where required.
- `CKV_GHA_7`: The manual deploy workflow uses limited `workflow_dispatch` inputs for a fixed action choice and cost-confirmation phrase.

## Dependabot

Dependabot opens pull requests when dependencies, Docker base images, Terraform providers, or GitHub Actions have updates.

Security meaning: dependency monitoring helps keep known vulnerable components from staying stale.

## Least-Privilege Workflow Permissions

Most workflows use:

```yaml
permissions:
  contents: read
```

The manual deploy workflow additionally uses:

```yaml
permissions:
  id-token: write
```

Security meaning: workflows should receive only the GitHub permissions they need.

## Manual-Only Deployment

The deploy workflow uses `workflow_dispatch` only. It does not run on push or pull request.

Security meaning: infrastructure changes should be intentional, reviewed, and protected from accidental triggers.
