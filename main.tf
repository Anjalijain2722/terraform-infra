provider "aws" {
  region = var.region
}
locals {
  deploy_vpc   = var.create_vpc
  deploy_redis = var.create_redis
}

module "vpc" {
  count    = local.deploy_vpc ? 1 : 0
  source   = "./modules/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

data "terraform_remote_state" "vpc" {
  count   = local.deploy_redis ? 1 : 0
  backend = "s3"

  config = {
    bucket = "reddis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = var.region
  }
}

module "redis" {
  count             = local.deploy_redis ? 1 : 0
  source            = "./modules/redis"
  cluster_id        = var.redis_cluster_id
  node_type         = var.redis_node_type
  num_cache_nodes   = var.redis_num_nodes
  depends_on        = [data.terraform_remote_state.vpc]
}
