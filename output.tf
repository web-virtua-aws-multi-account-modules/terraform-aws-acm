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
  value       = module.create_records_domain_validation
}

output "acm_certificate_validation" {
  description = "ACM certificate validation"
  value       = aws_acm_certificate_validation.create_acm_certificate_validation
}
