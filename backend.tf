terraform {
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "global/terraform.tfstate"
    region = "ap-south-1"
  }
}

