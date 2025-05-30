#
# The following variables MUST be set accordingly
#

variable "observe_workspace" {
  description = "The name of the Observe workspace"
  type        = string
  default     = "Default"
}

variable "organization_root_id" {
  description = "The ID of the AWS Organization root (e.g., r-xxxxxxxx)"
  type        = string
  default     = "CHANGEME"
}

variable "aws_account_map" {
  description = "Map of AWS account IDs to lists of regions"
  type        = map(list(string))
  default = {
    "123456789011" = ["us-east-1", "us-east-2"]
    "123456789012" = ["us-east-1", "us-west-2"]
  }
}

variable "custom_aws_account_map" {
  description = "Map of AWS account IDs to lists of regions to be excluded from default creation. It should be a subset of the overaching aws_account_map"
  type        = map(list(string))
  # default = {
  #   "1234" = ["us-east-1", "us-east-2"]
  # }
  # If there are no custom deployments, leave empty
  default = {}
}

variable "aws_management_account" {
  description = "The ID of the AWS Organization Management Account"
  type        = string
  default     = "123456789011"
}


#
# Optional variables for non-default deployments
#
variable "enable_iam_module" {
  type    = bool
  default = true
}

variable "cf_admin_role_arn" {
  type        = string
  description = "ARN to use if IAM module is not enabled"
  default     = ""
}

variable "stack_version" {
  type        = string
  description = "The version of the Observe Stack to use"
  default     = "2.7.0"
}