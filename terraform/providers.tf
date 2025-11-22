terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {} # pour commencer, tu peux plus tard mettre S3 backend
}
provider "null" {}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
