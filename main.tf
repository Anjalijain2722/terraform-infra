provider "aws" {
  region = var.region
}

locals {
  deploy_vpc   = var.create_vpc
  deploy_redis = var.create_redis
}

# VPC Module - only created if create_vpc = true
module "vpc" {
  count    = local.deploy_vpc ? 1 : 0
  source   = "./modules/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Load existing VPC from S3 state (only when Redis is being created)
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = var.region
  }
}

# Redis Module - only created if create_redis = true
module "redis" {
  count             = var.create_redis ? 1 : 0
  source            = "./modules/redis"
  region            = var.region
  redis_cluster_id  = var.redis_cluster_id
  redis_node_type   = var.redis_node_type
  redis_num_nodes   = var.redis_num_nodes
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
}
