data "aws_autoscaling_group" "web_asg" {
  name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_group" "web_asg" {
  name                = "WebServer-ASG"
  max_size            = var.web_asg_max_size
  min_size            = var.web_asg_min_size
  desired_capacity    = var.web_asg_desired_capacity
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.web_alb_target_group.arn]
  vpc_zone_identifier = var.web_subnets
  launch_template {
    id      = var.web_launch_template_id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  alb_target_group_arn   = aws_lb_target_group.web_alb_target_group.arn
}

resource "aws_lb" "web_alb" {
  name               = "webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.web_security_group_ids
  subnets            = var.web_subnets
}

resource "aws_lb_target_group" "web_alb_target_group" {
  name     = "Web-ALB-target-group"
  port     = var.web_port
  protocol = var.web_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = var.web_port
  protocol          = var.web_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_target_group.arn
  }
}


data "aws_autoscaling_group" "app_asg" {
  name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "AppServer-ASG"
  max_size            = var.app_asg_max_size
  min_size            = var.app_asg_min_size
  desired_capacity    = var.app_asg_desired_capacity
  target_group_arns   = [aws_lb_target_group.app_alb_target_group.arn]
  vpc_zone_identifier = var.app_subnets
  health_check_type   = "EC2"
  launch_template {
    id      = var.app_launch_template_id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "app_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  alb_target_group_arn   = aws_lb_target_group.app_alb_target_group.arn
}

resource "aws_lb" "app_alb" {
  name               = "appserver-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.app_security_group_ids
  subnets            = var.app_subnets
}

resource "aws_lb_target_group" "app_alb_target_group" {
  name     = "App-ALB-target-group"
  port     = var.app_port
  protocol = var.app_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.app_port
  protocol          = var.app_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}