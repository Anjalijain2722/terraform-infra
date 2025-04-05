terraform {
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "main/terraform.tfstate"
    region = "ap-south-1"
  }
}


