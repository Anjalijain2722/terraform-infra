terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "global/terraform.tfstate"
    region = "ap-south-1"
  }
}

