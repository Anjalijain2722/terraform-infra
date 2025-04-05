locals {
  is_vpc   = var.resource_type == "vpc"
  is_redis = var.resource_type == "redis"
}

# VPC provisioning block
module "vpc" {
  count    = local.is_vpc ? 1 : 0
  source   = "./module/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Read existing VPC from remote state (required for Redis)
data "terraform_remote_state" "vpc" {
  count   = local.is_redis ? 1 : 0
  backend = "s3"

  config = {
    bucket = "reddis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = var.region
  }
}

# Redis provisioning block
module "redis" {
  count             = local.is_redis ? 1 : 0
  source            = "./module/redis"
  cluster_id        = var.redis_cluster_id
  node_type         = var.redis_node_type
  num_cache_nodes   = var.redis_num_nodes

  # Optional: Example to demonstrate dependency (won’t be used directly)
  depends_on = [data.terraform_remote_state.vpc]
}
