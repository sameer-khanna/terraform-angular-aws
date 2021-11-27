output "ec2-public-ip" {
  value = aws_instance.web-server.public_ip
}