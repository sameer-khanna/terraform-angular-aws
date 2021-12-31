output "web-launch_template_id" {
  value = aws_launch_template.webserver-lt.id
}

output "web_security-group-ids" {
  value = aws_security_group.web-security-groups.*.public.id
}

output "app_security_group_id" {
  value = aws_security_group.app-security-group.id
}

output "db_security_group_id" {
  value = aws_security_group.db-security-group.id
}

output "app-launch_template_id" {
  value = aws_launch_template.appserver-lt.id
}

output "app_security-group-ids" {
  value = aws_security_group.web-security-groups.*.public.id
}

