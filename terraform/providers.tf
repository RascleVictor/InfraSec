terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {}
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  endpoints {
    ec2            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    s3             = "http://localhost:4566"
    sts            = "http://localhost:4566"
    route53        = "http://localhost:4566"
    rds            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
  }
}
