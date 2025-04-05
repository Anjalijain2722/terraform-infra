resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
}
resource "null_resource" "ensure_vpc_exists" {
  count = var.resource_type == "redis" && try(data.terraform_remote_state.vpc[0].outputs.vpc_id, "") == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'VPC not found! Cannot deploy Redis.' && exit 1"
  }
}
