output "web-alb-dns" {
  value = aws_lb.web_alb.dns_name
}

output "app-alb-dns" {
  value = aws_lb.app_alb.dns_name
}

output "alb-zone-id" {
  value = aws_lb.web_alb.zone_id
}

output "availability-zone" {
  value = data.aws_autoscaling_group.web_asg.availability_zones
}