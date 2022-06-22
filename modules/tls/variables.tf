variable "project" {
  description = "Project name"
}

# environment name: production, staging, qa, dev
variable "env" {
  description = "Project environment"
}

variable "cert_alias_domain_names" {
}

variable "cert_wildcard_domain" {
}