variable "cluster_id" {
  type        = string
  description = "The ID of the Redis cluster"
}

variable "node_type" {
  type        = string
  description = "The node type for the Redis cluster"
}

variable "num_cache_nodes" {
  type        = number
  description = "The number of Redis nodes"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID for Redis deployment"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Redis deployment"
}
