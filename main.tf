locals {
  create_vpc   = var.resource_type == "vpc"
  create_redis = var.resource_type == "redis"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  count  = local.create_vpc ? 1 : 0

  cidr_block = "10.0.0.0/16"
}

# Only include this block if Redis is being deployed
module "redis" {
  source     = "./modules/redis"
  count      = local.create_redis ? 1 : 0

  cluster_id  = local.create_redis ? "redis-test" : null
  node_type   = local.create_redis ? "cache.t3.micro" : null
  subnet_ids  = local.create_redis ? data.terraform_remote_state.vpc[0].outputs.subnet_ids : []
}
