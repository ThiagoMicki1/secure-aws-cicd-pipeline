# Least-Privilege IAM

Least privilege means granting only the permissions required for a task.

## What This Project Allows

The future GitHub Actions deploy role is limited to:

- Reading AWS caller identity
- Managing the project ECR repository
- Managing the project App Runner service
- Managing the project CloudWatch log group
- Passing only the App Runner ECR access role

## Why Some Actions Use Resource `*`

Some AWS actions, such as `ecr:GetAuthorizationToken`, do not support resource-level permissions. They require `Resource: "*"`.

That does not mean the entire policy is admin access. The broader action is limited to the smallest AWS API requirement, while project-specific actions are scoped to project resources.

## What This Project Avoids

- No `AdministratorAccess`
- No committed AWS keys
- No long-lived cloud credentials in GitHub
- No automatic deploy on push
- No wildcard `Action: "*"`

## Production Improvements

- Add IAM permission boundaries
- Use a dedicated AWS account for deployment experiments
- Add AWS budget alerts before deployment
- Add CloudTrail, AWS Config, and GuardDuty
- Review IAM Access Analyzer findings
