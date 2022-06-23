resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project}-${var.env}-eks-1"
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
  tags = {
    environment = var.env
    project     = var.project
    creator     = "terraform"
  }
}

resource "aws_eks_node_group" "general_nodes" {
  for_each = var.node_groups_config

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project}-${var.env}-${each.key}-eks-node-group-1"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn

  subnet_ids = var.subnet_ids

  capacity_type  = each.value["capacity_type"]
  instance_types = each.value["instance_types"]

  scaling_config {
    desired_size = each.value["scaling_config"]["desired_size"]
    max_size     = each.value["scaling_config"]["max_size"]
    min_size     = each.value["scaling_config"]["min_size"]
  }

  update_config {
    max_unavailable = each.value["update_config"]["max_unavailable"]
  }

  labels = {
    role = each.key
  }

  launch_template {
    name    = aws_launch_template.eks-general-launch-template.name
    version = aws_launch_template.eks-general-launch-template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-nodes-AmazonEKS_CNI_Policy,
  ]
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
  tags = {
    environment = var.env
    project     = var.project
    creator     = "terraform"
  }
}

# consider moving out to a module
resource "aws_launch_template" "eks-general-launch-template" {
  name     = "${var.project}-${var.env}-eks-general-launch-template"
  key_name = var.key_pair_name
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = var.node_volume_size
      volume_type = "gp2"
    }
  }
  tags = {
    environment = var.env
    project     = var.project
    creator     = "terraform"
  }
}

data "aws_eks_cluster_auth" "ephemeral" {
  name = aws_eks_cluster.eks_cluster.name
}
