
# VPCエンドポイント用のプライベートサブネット
resource "aws_subnet" "endpoint" {
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = local.cidr_blocks.endpoint
  vpc_id            = aws_vpc.main.id
}

resource "aws_network_acl" "endpoint" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.endpoint.id]
}

resource "aws_route_table" "endpoint" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "endpoint" {
  subnet_id      = aws_subnet.endpoint.id
  route_table_id = aws_route_table.endpoint.id
}

resource "aws_network_acl_rule" "subnet_endpoint_ingress" {
  network_acl_id = aws_network_acl.endpoint.id
  rule_action    = "allow"
  cidr_block     = "10.0.16.0/20"
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  rule_number    = "100"
  egress         = false
}

resource "aws_network_acl_rule" "subnet_endpoint_egress" {
  network_acl_id = aws_network_acl.endpoint.id
  rule_action    = "allow"
  cidr_block     = "10.0.16.0/20"
    from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  rule_number    = "100"
  egress         = true
}
