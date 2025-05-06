provider "aws" {}
data "aws_region" "current" {}

locals {
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

module "apigw" {
  source      = "./apigw"
  endpoint_id = aws_vpc_endpoint.apigw_endpoint.id
  pj_name     = "${local.name_prefix}-${local.Environment}-apigw"
}