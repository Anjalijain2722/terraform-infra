terraform {
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

# VPC Module (provision only if resource_type == "vpc")
module "vpc" {
  source       = "./modules/vpc"
  resource_type = var.resource_type
  count        = var.resource_type == "vpc" ? 1 : 0
}

# Remote state reference to fetch existing VPC (used by Redis)
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# Redis Module (provision only if resource_type == "redis")
module "redis" {
  source       = "./modules/redis"
  resource_type = var.resource_type
  count        = var.resource_type == "redis" ? 1 : 0

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

