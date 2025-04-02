module "redis" {
  source = "./modules/redis"
  selected_cluster_id = var.selected_cluster_ids[count.index]
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes

}

module "vpc" {
  source    = "./modules/vpc"
  region    = var.region
  vpc_cidr  = var.vpc_cidr
  vpc_name  = var.vpc_name
}
