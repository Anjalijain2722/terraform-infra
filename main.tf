provider "aws" {
  region = var.region
}

locals {
  is_vpc  = var.resource_type == "VPC"
  is_redis = var.resource_type == "ElastiCache-Redis"
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region

  # Only run if resource_type = "vpc"
  count = var.resource_type == "VPC" ? 1 : 0
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }

  # Only load if creating redis
  count = local.is_redis ? 1 : 0
}

module "redis" {
  source     = "./modules/redis"
  count      = local.is_redis ? 1 : 0
  region     = var.region
  vpc_id     = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  sg_id      = data.terraform_remote_state.vpc[0].outputs.redis_sg_id
}

