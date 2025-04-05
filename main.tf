module "vpc" {
  source      = "./modules/vpc"
  count       = var.resource_type == "vpc" ? 1 : 0
  vpc_name    = var.vpc_name
  cidr_block  = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  azs         = var.azs
}

module "redis" {
  source     = "./modules/redis"
  count      = var.resource_type == "redis" ? 1 : 0
  cluster_id = var.redis_cluster_id
  node_type  = var.redis_node_type
  subnet_ids = var.resource_type == "redis" ? data.terraform_remote_state.vpc.outputs.subnet_ids : []
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}
