####################
# ec2
####################
resource "aws_instance" "main" {
  instance_type          = var.default_instance_type
  ami                    = data.aws_ami.latest_amazon_linux2.id
  subnet_id              = aws_subnet.private_1a.id
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.example_profile.name
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true

    # EBSのNameタグ
    tags = {
      Name = "${local.name_prefix}-${local.Environment}"
    }
  }
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name = "${local.name_prefix}-${local.Environment}"
  }
}

####################
# security group
####################
resource "aws_security_group" "main" {
  name   = "${local.name_prefix}-${local.Environment}-sg"
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol  = "icmp"
    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  tags = {
    Name = "${local.name_prefix}-${local.Environment}-sg"
  }
}


####################
# ec2 iam role
####################
# インスタンスプロファイルを作成
resource "aws_iam_instance_profile" "example_profile" {
  name = "${local.name_prefix}-${local.Environment}-ssm"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name               = "${local.name_prefix}-${local.Environment}-ssm"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}