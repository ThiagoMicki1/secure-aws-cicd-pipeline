# Cost and Cleanup

This project does not deploy to AWS by default.

## Services That May Cost Money If Deployed

- AWS App Runner
- Amazon ECR storage
- CloudWatch Logs
- Data transfer
- Terraform-managed IAM and supporting resources

IAM itself usually does not create direct hourly cost, but permissions can enable services that do.

## Before Any Future Deployment

1. Set an AWS budget alert.
2. Use a sandbox AWS account.
3. Run `terraform plan`.
4. Review every resource.
5. Deploy only if you understand the cost.

## Cleanup Checklist

If you deploy later:

```bash
cd infra/terraform
terraform destroy -var-file="terraform.tfvars"
```

After destroy, verify in the AWS Console:

- App Runner service removed
- ECR repository/images removed
- CloudWatch log group removed
- GitHub OIDC IAM role removed
- No unexpected running resources remain
