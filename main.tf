# VPC creation (only when resource_type is vpc)
module "vpc" {
  source     = "./modules/vpc"
  create_vpc = var.create_vpc
  vpc_cidr   = var.vpc_cidr
  vpc_name   = var.vpc_name

  # Remove count to simplify logic and avoid module indexing
  # Terraform will evaluate this block regardless, but we’ll control usage with locals
}

# Remote VPC state for existing VPC (used by Redis)
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "reddis-testing-bucket"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Logic to choose between existing or newly created VPC
locals {
  use_existing_vpc = lower(var.resource_type) == "redis"

  vpc_id = local.use_existing_vpc
    ? data.terraform_remote_state.vpc.outputs.vpc_id
    : try(module.vpc.vpc_id, "")

  subnet_ids = local.use_existing_vpc
    ? data.terraform_remote_state.vpc.outputs.subnet_ids
    : try(module.vpc.subnet_ids, [])
}

# Redis creation (only when resource_type is redis)
module "redis" {
  source          = "./modules/redis"
  count           = lower(var.resource_type) == "redis" ? 1 : 0
  cluster_id      = var.redis_cluster_id
  node_type       = var.redis_node_type
  num_cache_nodes = var.redis_num_nodes
  vpc_id          = local.vpc_id
  subnet_ids      = local.subnet_ids
}
