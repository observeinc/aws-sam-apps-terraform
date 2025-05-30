terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    observe = {
      source = "terraform.observeinc.com/observeinc/observe"
    }
  }
  required_version = ">= 1.0"
}
