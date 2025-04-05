locals {
  vpc_provided = var.vpc_id != "" && length(var.subnet_ids) > 0
}

# Fail if VPC details not provided
resource "null_resource" "check_vpc" {
  count = local.vpc_provided ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'ERROR: VPC or subnet_ids missing. Redis cannot be created.' && exit 1"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "ElastiCache-Redis" {
  cluster_id           = "redis-cluster-demo"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids = var.security_group_ids


  depends_on = [aws_elasticache_subnet_group.redis]
}
