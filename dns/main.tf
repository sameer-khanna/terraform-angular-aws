data "aws_route53_zone" "primary-hosted-zone" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "sampleproject" {
  zone_id = data.aws_route53_zone.primary-hosted-zone.zone_id
  name    = "sampleproject-${substr(uuid(), 0, 4)}.${data.aws_route53_zone.primary-hosted-zone.name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_dns_zone_id
    evaluate_target_health = true
  }
}