output "administration_role_arn" {
  description = "ARN of the CloudFormation StackSet administration role"
  value       = aws_iam_role.stackset_admin_role.arn
}