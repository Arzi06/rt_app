# AWS profile
shared_credentials_file = "~/.aws/credentials"
profile                 = "default"
account                 = ["xxxxxxxx"]
# Provide your vpn IP
vpn_ip = ["xxxxxx/32", ]

# Provider AWS
region       = "us-east-1"
cluster_name = "eks_dev"

# VPC
cidr_block     = "10.0.0.0/16" # for VPC
private_subnet = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

# EKS
cluster_version = 1.18

# Cluster autoscaling group
spot_price           = "0.0464"
desired_capacity     = 1
max_size             = 1
min_size             = 1
on_demand_base       = 1
on_demand_percentage = 20
instance_types       = ["t2.medium", "t3a.medium", "t3.medium"] # uses by the autoscaling group when creating worker nodes
instance_type        = "t2.micro"                               #(for launch template)

