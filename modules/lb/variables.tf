# make ingress possible to connect to the load balancer
variable "cluster_name" {}
variable "project" {
  description = "Project name"
}

# environment name: production, staging, qa, dev
variable "env" {
  description = "Project environment"
}
variable "subnet_ids" {
  description = "Subnet IDs to use for the EKS cluster"
}
variable "vpc_id" {
  type = string
}

variable "certificate_arn" {}
