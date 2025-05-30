locals {
  # domain     = "observeinc.com"
  # customer   = "112274177706"
  # user_email = "wade@observeinc.com"
}

terraform {
  backend "local" {
    # bucket = "sockshop-terraform-state"
    # region = "us-west-2"
    # key    = "observe-eng.com/130639879024/workspace"
  }
}

provider "aws" {
  # region     = "us-east-1"
  # access_key = ""
  # secret_key = ""
}
#
# data "aws_secretsmanager_secret" "secret" {
#   name = format("tf-password-%s-%s", local.domain, local.customer)
# }
#
# data "aws_secretsmanager_secret_version" "secret" {
#   secret_id = data.aws_secretsmanager_secret.secret.id
# }

provider "observe" {
  # customer      = local.customer
  # domain        = local.domain
  # user_email    = local.user_email
  # user_password = "" //data.aws_secretsmanager_secret_version.secret.secret_string
}
