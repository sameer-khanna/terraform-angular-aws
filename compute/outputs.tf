# output "ec2-public-ip" {
#   value = aws_instance.web-server.public_ip
# }
output "launch_template_id" {
  value = aws_launch_template.webserver-lt.id
}

output "security-group-ids" {
  value = aws_security_group.security-groups.*.public.id
}

output "aws_instance_id" {
  value = aws_instance.web-server.id
}