resource "random_password" "master_password" {
  length  = 16
  special = false
}


resource "aws_ssm_parameter" "rds-username" {
  name        = "/dev/database/username"
  description = "Master DB User"
  type        = "SecureString"
  value       = var.db_username

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "rds-password" {
  name        = "/dev/database/password"
  description = "Master DB Password"
  type        = "SecureString"
  value       = random_password.master_password.result

  tags = {
    environment = "development"
  }
}

resource "aws_ssm_parameter" "rds-connection-string" {
  name        = "/dev/database/connectionstring"
  description = "DB connection string"
  type        = "SecureString"
  value       = var.connection_string

  tags = {
    environment = "development"
  }
}

