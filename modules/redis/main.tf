resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids
}
resource "aws_elasticache_cluster" "redis" {
  cluster_id          = "redis-cluster"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  parameter_group_name = "default.redis7.x"
}
