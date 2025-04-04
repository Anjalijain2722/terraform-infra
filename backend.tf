terraform {
  backend "s3" {
    bucket = "redis-testing-bucket"
    key    = "global/terraform.tfstate"
    region = "ap-south-1"
  }
}

