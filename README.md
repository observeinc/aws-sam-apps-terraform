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
  config_file            = "./config.yaml"

  stack_version          = "2.7.0"
  enable_iam_module      = true

  # enable_iam_module     = false
  # cf_admin_role_arn     = ""
  # cf_exec_role_name     = ""
}
```


# Example Config:

```



defaults:
  ConfigDeliveryBucketName: ""
  IncludeResourceTypes: ""
  ExcludeResourceTypes: ""
  LogGroupNamePatterns: "*"
  LogGroupNamePrefixes: ""
  ExcludeLogGroupNamePatterns: ""
  MetricStreamFilterUri: "s3://observeinc/cloudwatchmetrics/filters/recommended.yaml"
  MetricsPollerInterval: "5m"
  MetricNamespaces:
    - AWS/Firehose
  # MetricFilters:
  #   AWS/Firehose:
  #     MetricNames:
  #       - BytesPerSecondLimit
  SourceBucketNames: ""


accounts:
  238576302167:
    us-east-1:
      LogGroupNamePatterns: "prod"
      MetricsMode: "none"
      MetricsPollerInterval: "2m"
      MetricNamespaces:
        # - AWS/EC2
        - AWS/Firehose
        # - AWS/S3
      MetricFilters:
        AWS/Firehose:
          # MetricNames:
          #   - BytesPerSecondLimit
          #   - PutRequestsPerSecondLimit
          #   - RecordsPerSecondLimit
          Dimensions:
            - Key: DeliveryStreamName
              Value: observeinc-238576302167--us-east-1-LogWriter
          Tags:
            - Key: lambda:createdBy
              Values: [SAM]
    us-east-2: {}
  499691775255:
    us-east-1: {}
    eu-central-1: {}
```