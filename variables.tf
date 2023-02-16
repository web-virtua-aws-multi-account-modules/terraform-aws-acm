variable "name_prefix" {
  description = "Name prefix to resources"
  type        = string
}

variable "master_domain" {
  description = "Master domain"
  type        = string
}

variable "zone_id_route53" {
  description = "Zone ID of the Route 53 AWS"
  type        = string
  default     = null
}

variable "make_fqdn_records" {
  description = "If true create the fqdn records"
  type        = bool
  default     = true
}

variable "make_acm_validation" {
  description = "If true create the ACM validation"
  type        = bool
  default     = true
}

variable "alternatives_domains" {
  description = "Alternatives domains to master domain"
  type        = list(string)
  default     = null
}

variable "validation_method" {
  description = "Validation method, can be DNS, EMAIL or NONE, NONE is used when import certificate"
  type        = string
  default     = "DNS"
}

variable "validation_option" {
  description = "Optional configuration block used to specify information about the initial validation of each domain name"
  type = object({
    domain_name       = string
    validation_domain = string
  })
  default = null
}

variable "private_key" {
  description = "Private key if importing an existing certificate"
  type        = string
  default     = null
}

variable "certificate_body" {
  description = "Certificate body if importing an existing certificate"
  type        = string
  default     = null
}

variable "certificate_chain" {
  description = "Certificate chain if importing an existing certificate"
  type        = string
  default     = null
}

variable "certificate_authority_arn" {
  description = "Certificate authority ARN"
  type        = string
  default     = null
}

variable "early_renewal_duration" {
  description = "Early renewal duration"
  type        = number
  default     = null
}

variable "certificate_transparency_logging_preference" {
  description = "Certificate transparency logging preference, can be ENABLED or DISABLED"
  type        = string
  default     = null
}

variable "key_algorithm" {
  description = "Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data"
  type        = string
  default     = null
}

variable "use_tags_default" {
  description = "If true will be use the tags default to ACM"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to ACM"
  type        = map(any)
  default     = {}
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}
