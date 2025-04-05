data "terraform_remote_state" "vpc" {
  count  = local.create_redis ? 1 : 0
  backend = "s3"

  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}



