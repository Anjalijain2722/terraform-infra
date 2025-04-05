terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ──────────────────────────────
# VPC Module (only if requested)
# ──────────────────────────────
module "vpc" {
  count           = var.resource_type == "VPC" ? 1 : 0
  source          = "./modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
}

# ──────────────────────────────────────────────
# Fetch VPC Remote State if Redis is requested
# ──────────────────────────────────────────────
data "terraform_remote_state" "vpc" {
  count   = var.resource_type == "ElastiCache-Redis" ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# ────────────────────────────────
# Validation to prevent bad deploy
# ────────────────────────────────
locals {
  vpc_state_missing = (
    var.resource_type == "ElastiCache-Redis" &&
    length(data.terraform_remote_state.vpc) == 0
  )
}

# Throws error if remote state is missing
resource "null_resource" "validate_vpc_state" {
  count = local.vpc_state_missing ? 1 : 0

  provisioner "local-exec" {
    command = "echo '❌ VPC remote state not found! Cannot provision Redis without VPC.' && exit 1"
  }
}

# ──────────────────────────────
# Redis Module (only if requested)
# ──────────────────────────────
module "redis" {
  count               = var.resource_type == "ElastiCache-Redis" ? 1 : 0
  source              = "./modules/redis"
  vpc_id              = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids          = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  security_group_ids  = data.terraform_remote_state.vpc[0].outputs.security_group_ids
}
