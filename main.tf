provider "aws" {
  region = var.region
}

locals {
  is_vpc   = var.resource_type == "VPC"
  is_redis = var.resource_type == "ElastiCache-Redis"

  remote_vpc_id_exists     = local.is_redis ? try(data.terraform_remote_state.vpc[0].outputs.vpc_id, "") != "" : false
  remote_subnets_exist     = local.is_redis ? try(length(data.terraform_remote_state.vpc[0].outputs.subnet_ids), 0) > 0 : false
  remote_redis_sg_id_exist = local.is_redis ? try(data.terraform_remote_state.vpc[0].outputs.redis_sg_id, "") != "" : false

  is_remote_vpc_valid = local.remote_vpc_id_exists && local.remote_subnets_exist && local.remote_redis_sg_id_exist
}


# VPC Module
module "vpc" {
  count  = local.is_vpc ? 1 : 0
  source = "./modules/vpc"
  region = var.region
}

# Load VPC from remote state
data "terraform_remote_state" "vpc" {
  count = local.is_redis ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# Redis Module
module "redis" {
  count      = local.is_redis ? 1 : 0
  source     = "./modules/redis"
  region     = var.region

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids
  sg_id      = local.redis_sg_id
}

# Validate Remote VPC
resource "null_resource" "validate_remote_vpc" {
  count = local.is_redis && !local.is_remote_vpc_valid ? 1 : 0

  provisioner "local-exec" {
    command = "echo ' ERROR: Required VPC outputs not found in remote state.' && exit 1"
  }
}
