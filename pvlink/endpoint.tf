resource "aws_vpc_endpoint" "main" {
  for_each = {
    ec2         = "com.amazonaws.${data.aws_region.current.name}.ec2"
    ec2messages = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
    ssm         = "com.amazonaws.${data.aws_region.current.name}.ssm"
    ssmmessages = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  }

  service_name       = each.value
  vpc_endpoint_type  = "Interface"
  vpc_id             = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpc_endpoint.id]
  subnet_ids         = [aws_subnet.endpoint.id]
}

resource "aws_security_group" "vpc_endpoint" {
  description = "vpc-endpoint"
  name        = "vpc-endpoint"
  vpc_id      = aws_vpc.main.id
}

#ステップ4で作ったVPCエンドポイントのファイルの続き

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_ingress" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.vpc_endpoint.id
  cidr_ipv4         = local.cidr_blocks.endpoint
}
