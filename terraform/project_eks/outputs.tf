output "module_vps_id" {
  value = module.eks_cluster_dev.vpc_base
}

output "module_internet_gateway" {
  value = module.eks_cluster_dev.internet_gateway
}

output "module_aws_route_table" {
  value = module.eks_cluster_dev.aws_route_table
}

output "module_private_subnets" {
  value = module.eks_cluster_dev.private_subnets
}

output "module_public_subnets" {
  value = module.eks_cluster_dev.public_subnets
}

output "module_eks_security_group" {
  value = module.eks_cluster_dev.eks_security_group
}

output "module_security_group_rule_workstation" {
  value = module.eks_cluster_dev.security_group_rule_workstation
}

output "module_eks_iam_role" {
  value = module.eks_cluster_dev.eks_iam_role
}

output "module_eks_cluster" {
  value = module.eks_cluster_dev.eks_cluster
}

output "module_worker_iam_role" {
  value = module.eks_cluster_dev.worker_iam_role
}

output "module_worker_security_group" {
  value = module.eks_cluster_dev.worker_security_group
}

output "module_ami_worker_id" {
  value = module.eks_cluster_dev.ami_worker_id
}

output "module_worker_iam_instance_profile" {
  value = module.eks_cluster_dev.worker_iam_instance_profile
}

output "module_autoscaling_group" {
  value = module.eks_cluster_dev.autoscaling_group
}