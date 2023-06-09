# Create SSL Certificate using AWS ACM
resource "aws_acm_certificate" "shirt_color" {
  domain_name       = var.custom_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Validate SSL Certificate using DNS
resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.shirt_color.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.shirt_color.zone_id
}

# Retrieve SSL Certificate ARN from AWS ACM
resource "aws_acm_certificate_validation" "shirt_color" {
  certificate_arn         = aws_acm_certificate.shirt_color.arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
}
