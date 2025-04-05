terraform {
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  count  = var.resource_type == "VPC" ? 1 : 0
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
}

data "terraform_remote_state" "vpc" {
  count   = var.resource_type == "ElastiCache-Redis" ? 1 : 0
  backend = "s3"

  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

module "redis" {
  count = var.resource_type == "ElastiCache-Redis" ? 1 : 0

  source             = "./modules/redis"
  vpc_id             = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  security_group_ids = data.terraform_remote_state.vpc[0].outputs.security_group_ids
}
