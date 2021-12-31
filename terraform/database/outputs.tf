output "rds_connection_string" {
  value     = "jdbc:mysql://${aws_db_instance.rds.address}:${aws_db_instance.rds.port}/${var.name}"
  sensitive = true
}