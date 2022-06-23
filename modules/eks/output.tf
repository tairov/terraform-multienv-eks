output "eks_iam_role_arn" {
  value = aws_iam_role.eks_iam_role.arn
}

output "eks_iam_role_name" {
  value = aws_iam_role.eks_iam_role.name
}

output "eks_iam_node_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, null)
}

output "cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster
}

output "ephemeral_token" {
  value = data.aws_eks_cluster_auth.ephemeral.token
}