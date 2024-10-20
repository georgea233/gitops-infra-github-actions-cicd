data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240719.0-x86_64-gp2"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "security_groups" {
  for_each = var.security_groups

  name        = each.key
  description = "Security group for ${each.key}"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# locals {
#   filtered_instances = {
#     for k, v in var.instances : k => v
#     if contains(["dev", "stage", "prod"], v.environment)
#   }
# }

resource "aws_instance" "ec2_instances" {
  for_each = var.instances

  ami                         = each.value.ami == "amazon_linux" ? data.aws_ami.amazon_linux.id : data.aws_ami.ubuntu.id
  instance_type               = each.value.instance_type
  key_name                    = var.key_pair
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  iam_instance_profile        = aws_iam_instance_profile.ec2_admin_eks_profile.name
  security_groups             = [aws_security_group.security_groups[each.value.security_group].id]
  associate_public_ip_address = true

  tags = {
    Name = each.value.name
  }

  user_data = each.value.user_data != "" ? filebase64(each.value.user_data) : null
}
