#
# Required variables for authenticating to Observe
#

variable "observe_workspace" {
  description = "The name of the Observe workspace"
  type        = string
  default     = "Default"
}

variable "observe_domain" {
  description = "The name of the Observe workspace"
  type        = string
  default     = "observeinc.com"
}

variable "observe_customer_id" {
  description = "The name of the Observe workspace"
  type        = string
}

variable "observe_user" {
  description = "The name of the Observe workspace"
  type        = string
}

variable "observe_user_password" {
  description = "The name of the Observe workspace"
  type        = string
}

#
# Required variables for configuring the integration
#

variable "organization_root_id" {
  description = "The ID of the AWS Organization root (e.g., r-xxxxxxxx)"
  type        = string
}

variable "config_file" {
  description = "The local file path of the YAML configuration file"
  type        = string
}

variable "aws_management_account" {
  description = "The ID of the AWS Organization Management Account"
  type        = string
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

variable "cf_exec_role_name" {
  type        = string
  description = "Name of Cloudformation StackSet execution role to use if IAM module is not enabled"
  default     = ""
}

variable "stack_version" {
  type        = string
  description = "The version of the Observe Stack to use"
  default     = "2.7.0"
}