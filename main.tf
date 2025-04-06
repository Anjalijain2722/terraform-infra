# main.tf
variable "resource_type" {
  description = "Resource to create - either vpc or redis"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

locals {
  is_vpc   = var.resource_type == "vpc"
  is_redis = var.resource_type == "ElastiCache-Redis"
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

  vpc_id     = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  sg_id      = data.terraform_remote_state.vpc[0].outputs.redis_sg_id
}
