# CloudTrail and AWS Config Examples

This repo does not deploy CloudTrail or AWS Config by default. I kept the Terraform focused on the app pipeline so safe validation stays quick and cost-free.

For a real AWS deployment, I would add account-level audit logging before treating the pipeline as production-ready.

## CloudTrail

CloudTrail records AWS API activity. For this project, it would help answer questions like:

- Who pushed an image to ECR?
- Who changed App Runner, IAM, or repository settings?
- Was the manual deploy role assumed from GitHub Actions as expected?

Minimal future Terraform shape:

```hcl
resource "aws_cloudtrail" "account_audit" {
  name                          = "${var.project_name}-audit"
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
```

Before deploying this, I would also add an encrypted S3 log bucket, bucket policy for CloudTrail delivery, lifecycle retention, and cost review.

## AWS Config

AWS Config records resource configuration history. For this project, it would help track whether IAM roles, ECR repositories, App Runner services, or logging resources drift away from the intended baseline.

Minimal future Terraform shape:

```hcl
resource "aws_config_configuration_recorder" "baseline" {
  name     = "${var.project_name}-recorder"
  role_arn = aws_iam_role.config_recorder.arn
}

resource "aws_config_delivery_channel" "baseline" {
  name           = "${var.project_name}-delivery"
  s3_bucket_name = aws_s3_bucket.audit_logs.id
}
```

I would add Config only after deciding retention, recorder scope, and budget expectations. AWS Config can create ongoing charges depending on recorded resources and rule evaluations.

## Why This Is Documentation-Only For Now

Adding these resources directly to the current Terraform would make a future `terraform apply` create more billable AWS services. For this portfolio iteration, documenting the secure deployment path is safer than expanding infrastructure I am not ready to deploy yet.
