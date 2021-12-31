output "rds-master-username" {
  value     = aws_ssm_parameter.rds-username.value
  sensitive = true
}

output "rds-master-password" {
  value     = aws_ssm_parameter.rds-password.value
  sensitive = true
}

output "rds-connection-string" {
  value     = aws_ssm_parameter.rds-connection-string.value
  sensitive = true
}