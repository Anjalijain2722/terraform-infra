provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source   = "./modules/vpc"
  count    = var.resource_type == "vpc" || var.resource_type == "redis" ? 1 : 0
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "redis" {
  source = "./modules/redis"
  count  = var.resource_type == "redis" ? 1 : 0

  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes
  vpc_id           = module.vpc[0].vpc_id
}

output "vpc_id" {
  value = module.vpc[0].vpc_id
}
