# AWS ACM for multiples accounts and regions with Terraform module
* This module simplifies creating and configuring of the ACM across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of ACM configurations for this module:

- ACM certificate
- Records sets domain validation
- ACM certificate validation

## Usage exemples


### Create ACM certificate with domain record www

```hcl
module "acm_certificate_test_eks_luby_me" {
  source          = "web-virtua-aws-multi-account-modules/acm/aws"
  zone_id_route53 = data.aws_route53_zone.hosted_zone.zone_id
  name_prefix     = "acm-test-dominio.com"
  master_domain   = "test.com.br"

  alternatives_domains = [
    "www.test.com.br"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Create ACM certificate with domain record www without fqdn records
* OBS: If necessary validate a record in other AWS account will be necessary make some steps:
1. Set the make_fqdn_records and make_acm_validation variable as false
2. Execute the module to create ACM
3. Get the output with fqdn names
4. Make the new records with the fqdn names in account wished
5. Set the make_acm_validation variable as true and keep make_fqdn_records variable as false
6. Execute again the module to create ACM

```hcl
module "acm_certificate_test_eks_luby_me" {
  source              = "web-virtua-aws-multi-account-modules/acm/aws"
  zone_id_route53     = data.aws_route53_zone.hosted_zone.zone_id
  make_fqdn_records   = false
  make_acm_validation = false
  name_prefix         = "acm-test-dominio.com"
  master_domain       = "test.com.br"

  alternatives_domains = [
    "www.test.com.br"
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name_prefix | `string` | `-` | yes | Name prefix to resources | `-` |
| master_domain | `string` | `-` | yes | Master domain | `-` |
| zone_id_route53 | `string` | `-` | yes | Zone ID of the Route 53 AWS | `-` |
| make_fqdn_records | `bool` | `true` | no | If true create the fqdn records | `*`false <br> `*`true |
| make_acm_validation | `bool` | `true` | no | If true create the ACM validation | `*`false <br> `*`true |
| alternatives_domains | `list(string)` | `null` | no | Alternatives domains | `-` |
| validation_method | `string` | `DNS` | no | Validation method, can be DNS, EMAIL or NONE, NONE is used when import certificate | `*`DNS <br> `*`EMAIL <br> `*`NONE |
| validation_option | `object` | `null` | no | Optional configuration block used to specify information about the initial validation of each domain name | `-` |
| private_key | `string` | `null` | no | Private key if importing an existing certificate | `-` |
| certificate_body | `string` | `null` | no | Certificate body if importing an existing certificate | `-` |
| certificate_chain | `string` | `null` | no | Certificate chain if importing an existing certificate | `-` |
| certificate_authority_arn | `string` | `null` | no | Certificate authority ARN | `-` |
| early_renewal_duration | `number` | `null` | no | Early renewal duration | `-` |
| certificate_transparency_logging_preference | `string` | `null` | no | Certificate transparency logging preference  | `*`ENABLED <br> `*`DISABLED |
| key_algorithm | `string` | `null` | no | Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data | `-` |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to ACM | `*`false <br> `*`true |
| ou_name | `string` | `no` | no | Organization unit name | `-` |
| tags | `map(any)` | `{}` | no | Tags to ACM | `-` |

* Model of variable validation_option
```hcl
variable "validation_option" {
  type = object({
    domain_name       = string
    validation_domain = string
  })
  default = {
    domain_name       = "domain.com"
    validation_domain = "validate.domain.com
  }
}
```


## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.create_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.create_acm_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.create_record_route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `acm_certificate` | All ACM certificate |
| `acm_certificate_arn` | ACM certificate ARN |
| `acm_certificate_domain_validation_options` | ACM certificate domain validation options |
| `records_domain_validation` | Records domain validation |
| `acm_certificate_validation` | ACM certificate validation |
