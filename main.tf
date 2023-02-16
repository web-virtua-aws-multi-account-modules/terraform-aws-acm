locals {
  tags_acm = {
    "Name"   = "${var.name_prefix}"
    "tf-acm" = "${var.name_prefix}"
    "tf-ou"  = var.ou_name
  }
}

resource "aws_acm_certificate" "create_acm_certificate" {
  domain_name               = var.master_domain
  subject_alternative_names = var.alternatives_domains
  validation_method         = var.validation_method
  key_algorithm             = var.key_algorithm
  tags                      = merge(var.tags, var.use_tags_default ? local.tags_acm : {})
  private_key               = var.private_key
  certificate_body          = var.certificate_body
  certificate_chain         = var.certificate_chain
  certificate_authority_arn = var.certificate_authority_arn
  early_renewal_duration    = var.early_renewal_duration

  dynamic "validation_option" {
    for_each = var.validation_option != null ? [var.validation_option] : []

    content {
      domain_name       = validation_option.value.domain_name
      validation_domain = validation_option.value.validation_domain
    }
  }

  dynamic "options" {
    for_each = var.certificate_transparency_logging_preference != null ? [1] : []

    content {
      certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}

module "create_records_domain_validation" {
  count = var.make_fqdn_records ? 1 : 0

  source  = "web-virtua-aws-multi-account-modules/route53/aws"
  version = ">=1.0.0"

  set_one_zone_id_all_records = var.zone_id_route53

  records = flatten([
    for record in aws_acm_certificate.create_acm_certificate[*].domain_validation_options : [
      for rec in record : [
        {
          type = rec.resource_record_type
          name = rec.resource_record_name
          records = [
            rec.resource_record_value
          ]
        }
      ]
    ]
  ])

  depends_on = [
    aws_acm_certificate.create_acm_certificate
  ]
}

resource "aws_acm_certificate_validation" "create_acm_certificate_validation" {
  count = var.make_acm_validation ? 1 : 0

  certificate_arn = aws_acm_certificate.create_acm_certificate.arn
  validation_record_fqdns = flatten([
    for record in aws_acm_certificate.create_acm_certificate[*].domain_validation_options : [
      for rec in record : [
        rec.resource_record_name
      ]
    ]
  ])

  lifecycle {
    create_before_destroy = false
  }

  depends_on = [
    aws_acm_certificate.create_acm_certificate
  ]
}
