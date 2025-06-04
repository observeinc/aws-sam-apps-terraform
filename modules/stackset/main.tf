
locals {
  # CloudFormation depends on having the AWSCloudFormationStackSetAdministrationRole in place
  # It can be created automatically with this module
  # However, if already in place - you can skip this step and provide the Role ARN directly
  stackset_admin_iam_role_arn = (
    var.enable_iam_module
    ? module.iam["enabled"].administration_role_arn
    : var.cf_admin_role_arn
  )

  stackset_exec_iam_role_name = (
    var.enable_iam_module
    ? module.iam["enabled"].execution_role_name
    : var.cf_exec_role_name
  )

  enable_iam_module  = var.enable_iam_module ? { "enabled" = true } : {}

  #
  # Main AWS Account/Region Map is defined in a YAML config file
  #
  config = yamldecode(file(var.config_file))

  # Remaining local variables are based on the mapping in variables.
  # This creates the same mapping in a way that is easy for Terraform to parse
  
  # Flatten the account-region pairs
  account_region_pairs = flatten([
    for account, regions in local.config.accounts : [
      for region in keys(regions != null ? regions : {}) : {
        account = account
        region  = region
      }
    ]
  ])

  # Provides something Terraform can iterate over
  account_region_map = {
    for pair in local.account_region_pairs :
    "${pair.account}--${pair.region}" => pair
  }

  # Unique list of accounts
  aws_account_set = toset([for pair in local.account_region_pairs : pair.account])

  # Unique list of regions
  aws_region_set = toset([for pair in local.account_region_pairs : pair.region])
}

####################################################################################################
# Create IAM Roles
####################################################################################################
module "iam" {
  source   = "../iam"
  for_each = local.enable_iam_module

  organization_root_id   = var.organization_root_id
  aws_management_account = var.aws_management_account
  aws_account_set        = local.aws_account_set
}


####################################################################################################
# Create Observe FileDrop Instances
####################################################################################################

data "observe_workspace" "observe_workspace" {
  name = var.observe_workspace
}

data "observe_datastream" "aws" {
  workspace = data.observe_workspace.observe_workspace.oid
  name      = "AWS"
}

# this creates the filedrop in the Observe service. The AWS bucket and forwarders will
# still need be configured using the observe forwarder module using the following
# computed attributes from this resource:
# - observe_filedrop.example.endpoint.0.s3.0.arn
# - observe_filedrop.example.endpoint.0.s3.0.bucket
# - observe_filedrop.example.endpoint.0.s3.0.prefix
resource "observe_filedrop" "aws_filedrop" {
  for_each   = local.account_region_map
  workspace  = data.observe_workspace.observe_workspace.oid
  datastream = data.observe_datastream.aws.oid
  # The {each.key} is:  <account ID>--<region>
  name = "observeinc-${each.key}-forwarder-filedrop"
  config {
    provider {
      aws {
        # this is the region for the Observe bucket
        region = "us-west-2"
        # This Role reference allows customers to send data to Observe's hosted S3 bucket (FileDrop)
        # It MUST match what is created in the Observe Integration Stack (which is based on the Stack name)
        role_arn = "arn:aws:iam::${each.value.account}:role/observeinc-${each.key}-forwarder-filedrop"
      }
    }
  }
}


####################################################################################################
# CREATE OBSERVE INTEGRATION STACKSETS AND STACKSET INSTANCES
####################################################################################################
data "http" "observe_cf_templates" {
  for_each = local.aws_region_set

  url = "https://observeinc-${each.value}.s3.amazonaws.com/aws-sam-apps/${var.stack_version}/stack.yaml"
}

resource "aws_cloudformation_stack_set" "observe_aws_stackset" {
  depends_on = [module.iam]
  for_each = local.account_region_map

  # This name MUST align with the role referenced in the FileDrop creation
  name             = "observeinc-${each.key}"
  permission_model = "SELF_MANAGED"

  administration_role_arn = local.stackset_admin_iam_role_arn
  execution_role_name = local.stackset_exec_iam_role_name

  template_body = data.http.observe_cf_templates[each.value.region].response_body

  parameters = {
    # Destination parameters
    DestinationUri     = "s3://${observe_filedrop.aws_filedrop[each.key].endpoint[0].s3[0].bucket}/${observe_filedrop.aws_filedrop[each.key].endpoint[0].s3[0].prefix}"
    DataAccessPointArn = observe_filedrop.aws_filedrop[each.key].endpoint[0].s3[0].arn

    ConfigDeliveryBucketName = lookup(
      local.config.accounts[each.value.account][each.value.region], "ConfigDeliveryBucketName",
      local.config.defaults.ConfigDeliveryBucketName
    )
    IncludeResourceTypes     = lookup(
      local.config.accounts[each.value.account][each.value.region], "IncludeResourceTypes",
      local.config.defaults.IncludeResourceTypes
    )
    ExcludeResourceTypes     = lookup(
      local.config.accounts[each.value.account][each.value.region], "ExcludeResourceTypes",
      local.config.defaults.ExcludeResourceTypes
    )

    #
    # CloudWatch Logs
    # Comma separated lists
    LogGroupNamePatterns        = lookup(
      local.config.accounts[each.value.account][each.value.region], "LogGroupNamePatterns",
      local.config.defaults.LogGroupNamePatterns
    )
    LogGroupNamePrefixes        = lookup(
      local.config.accounts[each.value.account][each.value.region], "LogGroupNamePrefixes",
      local.config.defaults.LogGroupNamePrefixes
    )
    ExcludeLogGroupNamePatterns = lookup(
      local.config.accounts[each.value.account][each.value.region], "ExcludeLogGroupNamePatterns",
      local.config.defaults.ExcludeLogGroupNamePatterns
    )


    DebugEndpoint = ""
    #
    # CloudWatch Metrics
    #
    MetricStreamFilterUri = lookup(
      local.config.accounts[each.value.account][each.value.region], "MetricStreamFilterUri",
      local.config.defaults.MetricStreamFilterUri
    )
    ObserveAccountID      = ""
    ObserveDomainName     = ""
    DatasourceID          = ""
    GQLToken              = "****"
    UpdateTimestamp       = ""

    # Enable Observe Metrics Poller
    MetricsPollerAllowedActions = "cloudwatch:GetMetricData,cloudwatch:ListMetrics,tag:GetResources"
    # ObserveAwsAccountId         = "802757454165"
    ObserveAwsAccountId         = ""
    DatastreamIds               = ""

    #
    # Forwarder Options
    #
    # Comma separated list
    SourceBucketNames    = lookup(
      local.config.accounts[each.value.account][each.value.region], "SourceBucketNames",
      local.config.defaults.SourceBucketNames
    )
    ContentTypeOverrides = ""
    NameOverride         = "observeinc-${each.key}-forwarder"
  }

  capabilities = [
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND",
  ]
}

resource "aws_cloudformation_stack_set_instance" "observe_aws_stackset_instance" {
  depends_on = [module.iam]
  for_each       = local.account_region_map
  account_id     = each.value.account
  region         = each.value.region
  stack_set_name = aws_cloudformation_stack_set.observe_aws_stackset["${each.key}"].name
  call_as        = "SELF"
  retain_stack   = false

}



