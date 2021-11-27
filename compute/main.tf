
data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_ami" "latest-linux2-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "S3FullAccess-SSMCore" {
  name                = "S3AdminAccess+SSMCore"
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn, data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "webserver-instance-profile" {
  name = "WebServer-Instance-Profile"
  role = aws_iam_role.S3FullAccess-SSMCore.name
}

resource "aws_security_group" "security-groups" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
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

resource "aws_launch_template" "webserver-lt" {
  name          = "WebServer-LT"
  description   = "Web Server launch template created using Terraform."
  image_id      = data.aws_ami.latest-linux2-ami.id
  instance_type = var.instance_type
  network_interfaces {
    security_groups = aws_security_group.security-groups.*.public.id
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.webserver-instance-profile.arn
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver-fromLT"
    }
  }
  user_data = var.user_data
}

resource "aws_instance" "web-server" {
  subnet_id = var.subnet_id
  launch_template {
    id      = aws_launch_template.webserver-lt.id
    version = "$Latest"
  }
}