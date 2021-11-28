resource "aws_autoscaling_group" "asg" {
  name              = "WebServer-ASG"
  max_size          = var.asg_max_size
  min_size          = var.asg_min_size
  desired_capacity  = var.asg_desired_capacity
  health_check_type = "ELB"
  #   availability_zones = var.availability_zones
  target_group_arns = [aws_lb_target_group.alb_target_group.arn]
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
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

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.target_id
  port             = var.port
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