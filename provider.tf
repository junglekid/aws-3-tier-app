terraform {
  backend "s3" {
    bucket         = "dallin-tf-backend" 
    key            = "dallin-3-tier-app"
    region         = "us-west-2"
    profile        = "bsisandbox"
    encrypt        = true
    dynamodb_table = "dallin-tf-backend"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile

  default_tags {
    tags = {
      Provisoner  = "Terraform"
      Owner       = local.owner
      Environment = local.environment
      Project     = local.project
    }
  }
}
