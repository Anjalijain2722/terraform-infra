terraform {
  backend "s3" {
    bucket = "reddis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}



