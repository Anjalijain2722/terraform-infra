terraform {
  backend "s3" {
    bucket = "reddis-testing-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
