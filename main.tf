provider "aws" {
  region = "ap-south-1"
}

variable "resource_type" {
  description = "Choose 'vpc' or 'redis'"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "my-vpc"
}

variable "redis_cluster_id" {
  type    = string
  default = "redis-cluster"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "redis_num_nodes" {
  type    = number
  default = 1
}

module "vpc" {
  source   = "./modules/vpc"
  count    = var.resource_type == "vpc" || var.resource_type == "redis" ? 1 : 0
  region   = "ap-south-1"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "redis" {
  source = "./modules/redis"
  count  = var.resource_type == "redis" ? 1 : 0

  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes

  vpc_id           = module.vpc[0].vpc_id
}

output "vpc_id" {
  value = module.vpc[0].vpc_id
  description = "The ID of the created VPC"
  condition   = var.resource_type == "vpc" || var.resource_type == "redis"
}
