output "aws_route53_record" {
  value = aws_route53_record.sampleproject
}

output "zone_id" {
  value = data.aws_route53_zone.primary-hosted-zone.zone_id
}