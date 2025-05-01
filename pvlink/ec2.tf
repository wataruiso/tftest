resource "aws_instance" "main" {
  ami           = "ami-0e449927258d45bc4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  # key_name                    = "demo-key"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  availability_zone           = "${data.aws_region.current.name}a"
  iam_instance_profile        = aws_iam_instance_profile.systems_manager.name
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  vpc_id      = aws_vpc.main.id
  description = "ec2 security group"
}

# ステップ３で作ったEC2のファイルの続き

resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = local.cidr_blocks.private
}