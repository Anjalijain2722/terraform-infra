module "redis" {
  source = "./modules/redis"
  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes

}

module "vpc" {
  source    = "./modules/vpc"
  vpc_id = var.vpc_id
  region    = var.region
  vpc_cidr  = var.vpc_cidr
  vpc_name  = var.vpc_name
}
