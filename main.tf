module "vpc" {
  count   = var.resource_type == "vpc" ? 1 : 0
  source  = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

# Load existing VPC ID if it exists
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "redis" {
  count         = var.resource == "redis" ? 1 : 0
  source        = "./modules/redis"
  subnet_ids    = var.subnet_ids
  vpc_id        = try(data.terraform_remote_state.vpc.outputs.vpc_id, null)
}

# Error if Redis selected and VPC is missing
resource "null_resource" "check_vpc_exists" {
  count = var.resource == "redis" && try(data.terraform_remote_state.vpc.outputs.vpc_id, "") == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: VPC not found. Please create VPC first.' && exit 1"
  }
}
