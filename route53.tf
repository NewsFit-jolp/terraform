resource "aws_route53_zone" "newsfit_zone" {
  name = var.route53_zone_domain

  tags = {
    Name = "newsfit_zone"
  }
}

resource "aws_acm_certificate" "newsfit_certificate" {
  domain_name       = "*.${var.route53_zone_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "newsfit_certificate"
  }
}

resource "aws_route53_record" "newsfit_certificate_dns" {
  name    = tolist(aws_acm_certificate.newsfit_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.newsfit_certificate.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.newsfit_zone.zone_id
  records = [tolist(aws_acm_certificate.newsfit_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "newsfit_certificate_validation" {
  certificate_arn         = aws_acm_certificate.newsfit_certificate.arn
  validation_record_fqdns = [aws_route53_record.newsfit_certificate_dns.fqdn]
}

resource "aws_route53_record" "www" {
  name    = "www.${aws_route53_zone.newsfit_zone.name}"
  type    = "A"
  zone_id = aws_route53_zone.newsfit_zone.zone_id

  alias {
    name                   = aws_lb.newsfit_lb.dns_name
    zone_id                = aws_lb.newsfit_lb.zone_id
    evaluate_target_health = false
  }
}


output "name_servers" {
  description = "The name servers of the hosted zone"
  value       = aws_route53_zone.newsfit_zone.name_servers
}