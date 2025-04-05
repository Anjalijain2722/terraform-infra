output "redis_endpoint" {
  value       = length(aws_elasticache_cluster.redis) > 0 ? aws_elasticache_cluster.redis[0].cache_nodes[0].address : null
  description = "Endpoint of the Redis cluster"
}



