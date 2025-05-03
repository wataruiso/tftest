provider "aws" {}
data "aws_region" "current" {}

locals {
  aws_id      = var.aws_id
  name_prefix = "test"
  Environment = "dev"
  region      = data.aws_region.current.name
}

data "aws_ami" "latest_amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}