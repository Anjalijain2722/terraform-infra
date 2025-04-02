module "redis" {
  source = "./modules/redis"
  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes

}
