resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.cluster_id}-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id
}

resource "aws_elasticache_cluster" "redis" {
  count                = var.vpc_id != "" ? 1 : 0
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group[0].name

  depends_on = [aws_elasticache_subnet_group.redis_subnet_group]
}
