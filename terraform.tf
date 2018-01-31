provider "aws" {}

terraform {
  backend "s3" {
    bucket = "tfremotestatenic"
    key    = "cfmngmnt"
    region = "eu-west-1"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
