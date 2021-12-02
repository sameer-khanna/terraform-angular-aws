resource "aws_autoscaling_group" "asg" {
  name              = "WebServer-ASG"
  max_size          = var.asg_max_size
  min_size          = var.asg_min_size
  desired_capacity  = var.asg_desired_capacity
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.alb_target_group.arn]
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
}

resource "aws_lb" "alb" {
  name               = "webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnets
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "ALB-target-group"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}