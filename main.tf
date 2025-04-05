provider "aws" {
  region = var.region
}

# Determine what to deploy based on single input variable
locals {
  deploy_vpc   = var.resource_type == "vpc"
  deploy_redis = var.resource_type == "redis"
}

# Deploy VPC only when resource_type = "vpc"
module "vpc" {
  count    = local.deploy_vpc ? 1 : 0
  source   = "./modules/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Fetch remote state when deploying Redis only
data "terraform_remote_state" "vpc" {
  count   = local.deploy_redis ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = var.region
  }
}

# Deploy Redis only when resource_type = "redis"
module "redis" {
  count             = local.deploy_redis ? 1 : 0
  source            = "./modules/redis"
  cluster_id        = var.redis_cluster_id
  node_type         = var.redis_node_type
  num_cache_nodes   = var.redis_num_nodes

  # Access the VPC ID from remote state
  vpc_id            = data.terraform_remote_state.vpc[0].outputs.vpc_id

  depends_on        = [data.terraform_remote_state.vpc]
}

