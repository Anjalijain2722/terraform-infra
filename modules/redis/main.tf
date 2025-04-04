resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = ["subnet-0e4b65bfa1fc25815", "subnet-0670f6f8429aeb5ef"]  
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id          = "redis-cluster"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  parameter_group_name = "default.redis7"
  subnet_group_name   = aws_elasticache_subnet_group.redis_subnet_group.name
  vpc_security_group_ids = [var.security_group_id]
}
