output "web-fqdn" {
  value = aws_route53_record.sampleproject.fqdn
}

output "app-fqdn" {
  value = aws_route53_record.restapi-dns-record.fqdn
}