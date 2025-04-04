terraform {
  backend "s3" {
    bucket = "reddis-testing-bucket"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}
