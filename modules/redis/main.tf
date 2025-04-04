resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  parameter_group_name = "default.redis7"
  port                 = 6379

  depends_on = [aws_elasticache_subnet_group.redis_subnet_group]

  tags = {
    Name = var.cluster_id
  }
}
