output "ssl-cert" {
  value = aws_acm_certificate.ssl-cert
}

output "acm_certificate_validation" {
  value = aws_acm_certificate_validation.ssl-cert-validation
}