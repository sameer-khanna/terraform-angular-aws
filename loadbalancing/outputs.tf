output "alb-dns" {
  value = aws_lb.alb.dns_name
}

output "alb-zone-id" {
  value = aws_lb.alb.zone_id
}