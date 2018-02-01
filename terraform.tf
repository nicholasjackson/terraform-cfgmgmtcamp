provider "aws" {}

terraform {
  backend "s3" {
    bucket = "tfremotestatenic"
    key    = "cfmngmnt"
    region = "eu-west-1"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
}
