variable "cert_wildcard_domain" {
  type = string
}
variable "cert_alias_domain_names" {
  type = list(string)
}
variable "project" {
  type = string
}
variable "env" {
  type = string
}
variable "region" {
  type = string
}
variable "node_groups_config" {
  default = ""
}
variable "key_pair_name" {
  default = ""
}
variable "node_volume_size" {
  default = ""
}
variable "iam_role_additional_policies" {
  type = list(string)
}
variable "private_subnet_1_cidr" {
  type = string
}
variable "private_subnet_2_cidr" {
  type = string
}
variable "public_subnet_1_cidr" {
  type = string
}
variable "public_subnet_2_cidr" {
  type = string
}
variable "vpc_cidr" {
  type = string
}