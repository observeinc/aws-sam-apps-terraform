#
#  CREATE IAM ROLES FOR OBSERVE CF STACKSET
#
#  The StackSet and Instances created will require using a custom role
#  which is allowed wo run CloudFormation.  The enables using the SELF MANAGED
#  option which provides more flexibility for the Observe integration.
#
#  This uses a CF StackSet to create those roles in each account.
#  This uses the SERVICE MANAGED option for CloudFormation which avoids requiring a role itself.
#  However another limitaiton of the SERVICE managed option is it will exclude the root/management
#  account even when using the Roor Organization Unit.
#  Therefore the management account role is created with straight terraform below.
#
resource "aws_cloudformation_stack_set" "execution_role_setup" {
  name             = "CreateExecutionRole"
  template_body    = local.iam_stackset_template_body
  permission_model = "SERVICE_MANAGED"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  auto_deployment {
    enabled = true
  }

  # Being Service Managed, handled automatically
  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_set_instance" "execution_role_instances" {
  for_each = var.aws_account_set
  deployment_targets {
    organizational_unit_ids = [var.organization_root_id]
  }
  # Stackset Instance requires some region even if IAM is global.
  region         = "us-east-1"
  stack_set_name = aws_cloudformation_stack_set.execution_role_setup.name
}

#
#  CREATE MANAGEMENT ACCOUNT IAM ROLE FOR OBSERVE CF STACKSET
#
resource "aws_iam_role" "stackset_admin_role" {
  assume_role_policy = data.aws_iam_policy_document.stackset_admin_policy.json
  name               = "ObserveStackSetAdministrationRole"
}

data "aws_iam_policy_document" "stackset_admin_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["cloudformation.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_iam_role_policy" "stackset_admin_role_policy" {
  policy = data.aws_iam_policy_document.stackset_admin_permission_policy.json
  role   = aws_iam_role.stackset_admin_role.name
}



#
# CREATE EXECUTION ROLE IN MANAGEMENT ACCOUNT
#
data "aws_iam_policy_document" "stackset_exe_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.stackset_admin_role.arn]
    }
  }
}
data "aws_iam_policy_document" "stackset_admin_permission_policy" {
  statement {
    actions   = ["*"]
    effect    = "Allow"
    resources = ["*"]
  }
}
resource "aws_iam_role" "stackset_exe_role" {
  assume_role_policy = data.aws_iam_policy_document.stackset_exe_trust_policy.json
  name               = "ObserveStackSetExecutionRole"
}
resource "aws_iam_role_policy" "stackset_exe_role_policy" {
  policy = data.aws_iam_policy_document.stackset_admin_permission_policy.json
  role   = aws_iam_role.stackset_exe_role.name
}