locals {
  iam_stackset_template_body = <<EOF
Resources:
  StackSetExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: ObserveStackSetExecutionRole
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              AWS: "arn:aws:iam::${var.aws_management_account}:role/ObserveStackSetAdministrationRole"
            Action: sts:AssumeRole
      Policies:
        - PolicyName: AllowBasicResources
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - cloudformation:DescribeStacks
                  - cloudformation:CreateStack
                  - cloudformation:UpdateStack
                  - cloudformation:DeleteStack
                  - cloudformation:DescribeStackResources
                  - cloudformation:GetTemplate
                  - cloudformation:ValidateTemplate
                  - cloudformation:TagResource
                Resource: "arn:aws:cloudformation:*:*:stack/*/*"
              - Effect: Allow
                Action:
                  - sns:CreateTopic
                  - sns:DeleteTopic
                  - sns:Subscribe
                  - sns:Unsubscribe
                  - sns:Publish
                  - sns:SetTopicAttributes
                  - sns:GetTopicAttributes
                  - sns:ListSubscriptionsByTopic
                  - sns:TagResource
                Resource: "arn:aws:sns:*:*:*"
              - Effect: Allow
                Action:
                  - s3:CreateBucket
                  - s3:DeleteBucket
                  - s3:PutBucketPolicy
                  - s3:GetBucketPolicy
                  - s3:PutBucketNotification
                  - s3:GetBucketNotification
                  - s3:PutBucketLifecycleConfiguration
                  - s3:GetBucketLifecycleConfiguration
                  - s3:PutObject
                  - s3:GetObject
                  - s3:DeleteObject
                  - s3:ListBucket
                  - s3:PutBucketTagging
                  - s3:PutLifecycleConfiguration
                  - s3:PutBucketTagging
                Resource:
                  - "arn:aws:s3:::*"
                  - "arn:aws:s3:::*/*"
              - Effect: Allow
                Action:
                  - lambda:CreateFunction
                  - lambda:DeleteFunction
                  - lambda:UpdateFunctionCode
                  - lambda:UpdateFunctionConfiguration
                  - lambda:GetFunction
                  - lambda:InvokeFunction
                  - lambda:AddPermission
                  - lambda:RemovePermission
                  - lambda:ListFunctions
                  - lambda:TagResource
                Resource:
                  - "arn:aws:lambda:*:*:*"
              - Effect: Allow
                Action:
                  - lambda:CreateEventSourceMapping
                  - lambda:DeleteEventSourceMapping
                  - lambda:GetEventSourceMapping
                Resource:
                  - "*"
              - Effect: Allow
                Action:
                  - logs:CreateLogGroup
                  - logs:DeleteLogGroup
                  - logs:PutRetentionPolicy
                  - logs:DescribeLogGroups
                  - logs:CreateLogStream
                  - logs:DeleteLogStream
                  - logs:PutLogEvents
                  - logs:GetLogEvents
                  - logs:DescribeLogStreams
                  - logs:TagResource
                Resource: "arn:aws:logs:*:*:*"
              - Effect: Allow
                Action:
                  - cloudwatch:PutMetricData
                  - cloudwatch:GetMetricData
                  - cloudwatch:ListMetrics
                  - cloudwatch:GetMetricStatistics
                  - cloudformation:CreateChangeSet
                  - cloudwatch:GetMetricStream
                  - cloudwatch:PutMetricStream
                  - cloudwatch:DeleteMetricStream
                  - cloudwatch:TagResource
                Resource: "*"
              - Effect: Allow
                Action:
                  - iam:CreateRole
                  - iam:DeleteRole
                  - iam:AttachRolePolicy
                  - iam:DetachRolePolicy
                  - iam:PassRole
                  - iam:GetRole
                  - iam:PutRolePolicy
                  - iam:DeleteRolePolicy
                  - iam:GetRolePolicy
                  - iam:TagRole
                  - iam:TagPolicy
                Resource: "arn:aws:iam::*:*"
              - Effect: Allow
                Action:
                  - events:PutRule
                  - events:DeleteRule
                  - events:DescribeRule
                  - events:EnableRule
                  - events:DisableRule
                  - events:PutTargets
                  - events:RemoveTargets
                  - events:TagResource
                Resource: "arn:aws:events:*:*:rule/*"
              - Effect: Allow
                Action:
                  - kinesis:CreateStream
                  - kinesis:DeleteStream
                  - kinesis:PutRecord
                  - kinesis:PutRecords
                  - kinesis:GetShardIterator
                  - kinesis:GetRecords
                  - kinesis:DescribeStream
                  - kinese:TagStream
                Resource: "arn:aws:kinesis:*:*:*"
              - Effect: Allow
                Action:
                  - firehose:DescribeDeliveryStream
                  - firehose:TagDeliveryStream
                  - firehose:CreateDeliveryStream
                  - firehose:DeleteDeliveryStream
                Resource: "arn:aws:firehose:*:*:deliverystream/*"
              - Effect: Allow
                Action:
                  - sqs:CreateQueue
                  - sqs:DeleteQueue
                  - sqs:GetQueueAttributes
                  - sqs:GetQueueUrl
                  - sqs:ListDeadLetterSourceQueues
                  - sqs:ListMessageMoveTasks
                  - sqs:ListQueueTags
                  - sqs:ListQueues
                  - sqs:SetQueueAttributes
                  - sqs:TagQueue
                  - sqs:UntagQueue
                Resource: "arn:aws:sqs:*:*:*"
              - Effect: Allow
                Action:
                  - scheduler:GetSchedule
                  - scheduler:CreateSchedule
                  - scheduler:UpdateSchedule
                  - scheduler:DeleteSchedule
                  - scheduler:ListSchedules
                  - scheduler:TagResource
                Resource: "arn:aws:scheduler:*:*:schedule/*"
EOF
}