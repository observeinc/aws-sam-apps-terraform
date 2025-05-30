variable "organization_root_id" {
  description = "The ID of the AWS Organization root (e.g., r-xxxxxxxx)"
  type        = string
}

variable "aws_account_set" {
  description = "Set of AWS account IDs extracted from account_region_pairs"
  type        = set(string)
}

variable "aws_management_account" {
  description = "The ID of the AWS Organization root (e.g., r-xxxxxxxx)"
  type        = string
}