data "aws_route53_zone" "primary-hosted-zone" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "sampleproject" {
  zone_id = data.aws_route53_zone.primary-hosted-zone.zone_id
  name    = "sampleproject-${substr(uuid(), 0, 4)}.${data.aws_route53_zone.primary-hosted-zone.name}"
  type    = "A"
  lifecycle {
    ignore_changes = [name]
  }
  alias {
    name                   = var.web_alb_dns_name
    zone_id                = var.web_alb_dns_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "private-hosted-zone" {
  name = var.private_hosted_zone_name

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "restapi-dns-record" {
  zone_id = aws_route53_zone.private-hosted-zone.zone_id
  name    = "api.${aws_route53_zone.private-hosted-zone.name}"
  type    = "A"
  alias {
    name                   = var.app_alb_dns_name
    zone_id                = var.app_alb_dns_zone_id
    evaluate_target_health = true
  }
}
