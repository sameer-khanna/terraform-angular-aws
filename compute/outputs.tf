output "launch_template_id" {
  value = aws_launch_template.webserver-lt.id
}

output "security-group-ids" {
  value = aws_security_group.security-groups.*.public.id
}
