
# EC2用のプライベートサブネット
resource "aws_subnet" "private" {
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = local.cidr_blocks.private
  vpc_id            = aws_vpc.main.id
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ステップ１で作成した、EC2用のプライベートサブネットのファイルの続き

resource "aws_network_acl_rule" "subnet_private1_ingress" {
  network_acl_id = aws_network_acl.private.id
  rule_action    = "allow"
  cidr_block     = "10.0.48.0/20"
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  rule_number    = "100"
  egress         = false
}

resource "aws_network_acl_rule" "subnet_private1_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_action    = "allow"
  cidr_block     = "10.0.48.0/20"
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  rule_number    = "100"
  egress         = true
}
