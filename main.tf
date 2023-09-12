module "vpc" {
  source = "./modules/vpc"

  project               = var.project
  env                   = var.env
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  vpc_cidr              = var.vpc_cidr

  # needed for shared load balancer integration
  eks_cluster_name = "${var.project}-${var.env}-eks-1"
}

module "tls" {
  source                  = "./modules/tls"
  project                 = var.project
  env                     = var.env
  cert_alias_domain_names = var.cert_alias_domain_names
  cert_wildcard_domain    = var.cert_wildcard_domain
}

module "eks" {
  source = "./modules/eks"

  project    = var.project
  env        = var.env
  subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
  node_groups_config           = var.node_groups_config
  key_pair_name                = var.key_pair_name
  node_volume_size             = var.node_volume_size
  iam_role_additional_policies = var.iam_role_additional_policies
}


