variable "cluster_id" {
  description = "The ID for the Redis cluster"
  type        = string
}

variable "redis_node_type" {
  description = "Instance type for Redis"
  type        = string
}

variable "redis_num_nodes" {
  description = "Number of cache nodes"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID where Redis will be launched"
  type        = string
}





