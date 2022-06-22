resource "aws_acm_certificate" "cert" {
  domain_name               = var.cert_wildcard_domain
  subject_alternative_names = var.cert_alias_domain_names
  validation_method         = "DNS"

  tags = {
    Name        = "${var.project}-${var.env}-tls-certification"
    environment = var.env
    project     = var.project
    creator     = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}
