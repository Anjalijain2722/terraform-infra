provider "aws" {
  region = "ap-south-1"
}

# VPC Module (only if resource_type == "vpc")
module "vpc" {
  source        = "./modules/vpc"
  resource_type = var.resource_type
  vpc_cidr_block  = var.vpc_cidr_block
  count         = var.resource_type == "vpc" ? 1 : 0
}

# Remote state to read existing VPC
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# Redis Module (only if resource_type == "ElastiCache-Redis")
module "redis" {
  source     = "./modules/redis"
  count      = var.resource_type == "ElastiCache-Redis" ? 1 : 0
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_group_ids = [data.terraform_remote_state.vpc.outputs.redis_sg_id]
}
