output "acm_certificate" {
  description = "ACM certificate"
  value       = aws_acm_certificate.create_acm_certificate
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.create_acm_certificate.arn
}

output "acm_certificate_domain_validation_options" {
  description = "ACM certificate domain validation options"
  value       = aws_acm_certificate.create_acm_certificate[*].domain_validation_options
}

output "records_domain_validation" {
  description = "Records domain validation"
  value       = try(module.create_records_domain_validation[0], null)
}

output "acm_certificate_validation" {
  description = "ACM certificate validation"
  value       = try(aws_acm_certificate_validation.create_acm_certificate_validation[0], null)
}

output "fqdn_records" {
  description = "List fqdn records"
  value = flatten([
    for record in aws_acm_certificate.create_acm_certificate[*].domain_validation_options : [
      for rec in record : [{
        name  = rec.resource_record_name
        value = rec.resource_record_value
        value = rec.resource_record_type
      }]
    ]
  ])
}
