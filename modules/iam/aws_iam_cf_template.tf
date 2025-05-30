locals {
  stack_version = "2.7.0"
  iam_stackset_template_body = <<EOF
Resources:
  StackSetExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: AWSCloudFormationStackSetExecutionRole
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              AWS: "arn:aws:iam::${var.aws_management_account}:role/AWSCloudFormationStackSetAdministrationRole"
            Action: sts:AssumeRole
      Policies:
        - PolicyName: AllowBasicResources
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action: "*"
                Resource: "*"
EOF
}