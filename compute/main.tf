
data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = var.iam_managed_policy_s3
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = var.iam_managed_policy_ssm
}

data "aws_ami" "latest-linux2-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }
  filter {
    name   = "architecture"
    values = [var.ami_filter_architecture]
  }
  owners = [var.ami_owner]
}

resource "aws_iam_role" "S3FullAccess-SSMCore" {
  name                = "S3AdminAccess+SSMCore"
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn, data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn]
  assume_role_policy  = var.iam_role_trust_policy
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "WebServer-Instance-Profile"
  role = aws_iam_role.S3FullAccess-SSMCore.name
}

resource "aws_security_group" "web-security-groups" {
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
    from_port   = var.sg_egress_from_port
    to_port     = var.sg_egress_to_port
    protocol    = var.sg_egress_Protocol
    cidr_blocks = [var.sg_egress_cidr]
  }

}

resource "aws_security_group" "app-security-group" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = var.vpc_id
  ingress {
    from_port       = var.app_sg_from_port
    to_port         = var.app_sg_to_port
    protocol        = var.app_sg_protocol
    security_groups = aws_security_group.web-security-groups.*.public.id
    self            = true
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_launch_template" "webserver-lt" {
  name          = "WebServer-LT"
  description   = "Web Server launch template created using Terraform."
  image_id      = data.aws_ami.latest-linux2-ami.id
  instance_type = var.instance_type
  network_interfaces {
    security_groups = aws_security_group.web-security-groups.*.public.id
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.instance-profile.arn
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver-fromLT"
    }
  }
  user_data = var.user_data
}

resource "aws_launch_template" "appserver-lt" {
  name          = "AppServer-LT"
  description   = "App Server launch template created using Terraform."
  image_id      = var.appserver_ami_id
  instance_type = var.instance_type
  network_interfaces {
    security_groups = [aws_security_group.app-security-group.id]
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.instance-profile.arn
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "appserver-fromLT"
    }
  }
}