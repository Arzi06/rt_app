output "vpc_base" {
    value = aws_vpc.vpc.id
}

output "internet_gateway" {
    value = aws_internet_gateway.internet_gateway_dev.id
}

output "aws_route_table" {
    value = aws_route_table.public_rt_dev.id
}

output "private_subnets" {
    value = aws_subnet.private[*].id
}

output "public_subnets" {
    value = aws_subnet.public[*].id
}

output "eks_security_group" {
    value = aws_security_group.eks.id
}

output "security_group_rule_workstation" {
    value = aws_security_group_rule.cluster-ingress-workstation-https.id
}

output "eks_iam_role" {
    value = aws_iam_role.eks.arn
}

output "eks_cluster" {
    value = aws_eks_cluster.eks.id
}

output "worker_iam_role" {
    value = aws_iam_role.worker.arn
}

output "worker_security_group" {
    value = aws_security_group.worker.id
}

output "ami_worker_id" {
    value = data.aws_ami.eks_worker.id
}

output "worker_iam_instance_profile" {
    value = aws_iam_instance_profile.worker.name
}

output "launch_template" {
    value = aws_launch_template.worker.name
}

output "autoscaling_group" {
    value = aws_autoscaling_group.workers.name
}