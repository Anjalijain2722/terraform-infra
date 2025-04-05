resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "ElastiCache-Redis" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids   = var.security_group_ids
}

locals {
  vpc_valid = var.vpc_id != ""
}

resource "null_resource" "check_vpc" {
  count = local.vpc_valid ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'ERROR: VPC is required for Redis. Please create a VPC first.' && exit 1"
  }
}
