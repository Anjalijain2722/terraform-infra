provider "aws" {
  region = var.region
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

module "vpc" {
  source     = "./modules/vpc"
  count      = var.create_vpc ? 1 : 0
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr
}

module "redis" {
  source          = "./modules/redis"
  count           = var.create_redis ? 1 : 0

  vpc_id          = data.terraform_remote_state.vpc.outputs["vpc_id"]
  subnet_ids      = data.terraform_remote_state.vpc.outputs["subnet_ids"]
  cluster_id      = var.cluster_id
  redis_node_type = var.redis_node_type
  redis_num_nodes = var.redis_num_nodes
}
