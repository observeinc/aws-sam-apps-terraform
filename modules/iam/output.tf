output "administration_role_arn" {
  description = "ARN of the CloudFormation StackSet administration role"
  value       = aws_iam_role.stackset_admin_role.arn
}

output "execution_role_name" {
  description = "Name of the CloudFormation StackSet execution role"
  value       = aws_iam_role.stackset_exe_role.name
}