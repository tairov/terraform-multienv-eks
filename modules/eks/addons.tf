data "aws_eks_addon_version" "this" {
  for_each = {for k, v in var.cluster_addons : k => v}

  addon_name         = try(each.value.name, each.key)
  kubernetes_version = aws_eks_cluster.eks_cluster.version
  most_recent        = try(each.value.most_recent, null)
}

resource "aws_eks_addon" "this" {
  # Not supported on outposts
  for_each = {
    for k, v in var.cluster_addons : k => v
  }

  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = try(each.value.name, each.key)

  addon_version            = try(each.value.addon_version, data.aws_eks_addon_version.this[each.key].version)
  configuration_values     = try(each.value.configuration_values, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [
    aws_eks_node_group.general_nodes
  ]

  tags = {
    environment = var.env
    project     = var.project
    creator     = "terraform"
  }
}