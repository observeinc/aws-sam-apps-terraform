

provider "aws" {}

provider "observe" {
  customer      = var.observe_customer_id
  domain        = var.observe_domain
  user_email    = var.observe_user
  user_password = var.observe_user_password
}
