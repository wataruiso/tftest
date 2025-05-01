locals {
  name = "sample"
  cidr_blocks = {
    vpc      = "10.0.0.0/16"
    private  = "10.0.16.0/20"
    endpoint = "10.0.48.0/20"
  }
}

# VPC
# 10.0.0.0/16 は全体のアドレス範囲
# 10.0.0.0/18 はリージョン、AZ用(4個) 
# 10.0.0.0/20 はサブネット用(４個)
# アドレス部は12ビット(=4096-5個)

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_blocks.vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = local.name
  }
}