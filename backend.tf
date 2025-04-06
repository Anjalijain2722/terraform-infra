terraform {
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}



