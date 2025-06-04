# aws-sam-apps-terraform
The terraform module to facilliate deploying the latest Observe AWS Integration based on CloudFormation

# Example Usage:

```
module "observe_aws" {
  source = "github.com/observeinc/aws-sam-apps-terraform//modules/stackset"

  observe_user          = "wade@observeinc.com"
  observe_user_password = "REDACT"
  observe_customer_id   = "190558161486"
  observe_domain        = "observe-staging.com"
  # observe_workspace     = "Default"

  organization_root_id   = "r-itll"
  aws_management_account = "238576302167"
  aws_account_map = {
    "238576302167" = ["us-east-1", "us-east-2"]
    "499691775255" = ["us-east-1", "eu-central-1"]
  }

  stack_version          = "2.7.0"
  enable_iam_module      = true

  # enable_iam_module     = false
  # cf_admin_role_arn     = ""
  # cf_exec_role_name     = ""
}
```