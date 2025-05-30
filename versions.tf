terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
    observe = {
      source  = "terraform.observeinc.com/observeinc/observe"
      version = "~> 0.14.30"
    }
  }
  required_version = ">= 1.0"
}
