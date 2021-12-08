resource "aws_acm_certificate" "ssl-cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ssl-cert-validation" {
  certificate_arn         = aws_acm_certificate.ssl-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.ssl-cert-validation-record : record]
}

resource "aws_route53_record" "ssl-cert-validation-record" {
  # for_each = {
  #   for dvo in aws_acm_certificate.ssl-cert.domain_validation_options : dvo.domain_name => {
  #     name   = dvo.resource_record_name
  #     record = dvo.resource_record_value
  #     type   = dvo.resource_record_type
  #   }
  # }
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl-cert.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl-cert.domain_validation_options)[0].resource_record_value]
  ttl             = 60
  type            = tolist(aws_acm_certificate.ssl-cert.domain_validation_options)[0].resource_record_type
  zone_id         = var.zone_id
  #   name    = each.value.name
  #   records = [each.value.record]
  #   type    = each.value.type
}
