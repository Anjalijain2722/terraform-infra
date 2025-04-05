locals {
  is_vpc  = var.resource_type == "vpc"
  is_redis = var.resource_type == "ElastiCache-Redis"
}

module "vpc" {
  source         = "./modules/vpc"
  count          = local.is_vpc ? 1 : 0
  region         = var.region
  vpc_cidr_block = "10.0.0.0/16"
}


data "terraform_remote_state" "vpc" {
  count   = local.is_redis ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = var.region
  }
}

resource "null_resource" "vpc_check" {
  count = local.is_redis && (length(data.terraform_remote_state.vpc[0].outputs) == 0 ? 1 : 0)
  provisioner "local-exec" {
    command = "echo 'VPC not found. Cannot create Redis without VPC.' && exit 1"
  }
}

module "redis" {
  source       = "./modules/redis"
  count        = local.is_redis ? 1 : 0
  region       = var.region
  vpc_id       = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids   = data.terraform_remote_state.vpc[0].outputs.subnet_ids
}
