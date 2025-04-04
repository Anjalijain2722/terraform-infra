provider "aws" {
  region = var.region
}

# VPC Module (only if creating VPC)
module "vpc" {
  source   = "./modules/vpc"
  count    = lower(var.resource_type) == "vpc" ? 1 : 0
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Data source to get VPC ID from existing remote state (only when not creating VPC)
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "reddis-testing-bucket"
    key    = "terraform.tfstate" 
    region = "ap-south-1"
  }
}

# Redis Module (use existing VPC)
module "redis" {
  source = "./modules/redis"
  count  = count = contains(["redis", "elasticache-redis"], lower(var.resource_type)) ? 1 : 0
  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes
  vpc_id = lower(var.resource_type) == "vpc" ? module.vpc[0].vpc_id : data.terraform_remote_state.vpc.outputs.vpc_id
}

# Output only when VPC is created
output "vpc_id" {
  value = lower(var.resource_type) == "vpc" ? module.vpc[0].vpc_id : null
  description = "VPC ID created when resource_type is vpc"
}

output "existing_vpc_id" {
  value       = contains(["redis", "elasticache-redis"], lower(var.resource_type)) ? data.terraform_remote_state.vpc.outputs.vpc_id : null
  description = "VPC ID from remote state when creating Redis"
}




