terraform {
  backend "s3" {
    bucket = "tfstate-s3-bucket-178371640375-eu-south-1-an"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-south-1"
  }
}
