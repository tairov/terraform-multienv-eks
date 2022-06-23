variable "project" {
  description = "Project name"
}

# environment name: production, staging, qa, dev
variable "env" {
  description = "Project environment"
}

variable "region" {
  default     = "eu-west-1"
  description = "AWS Region"
}
variable "subnet_ids" {
  description = "Subnet IDs to use for the EKS cluster"
}

# it's possible to create multiple node groups
variable "node_groups_config" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    # SPOT or ON_DEMAND
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable = number
    })
  }))
}

variable "key_pair_name" {
  type = string
}

variable "node_volume_size" {
  type = number
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

# attach additional policies to the node group role
variable "iam_role_additional_policies" {
  type = list(string)
}
