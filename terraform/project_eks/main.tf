# Terraform Block
terraform {
  required_version = "~> 1.0" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
  # assume_role {
  #  role_arn              = var.role_arn
  # }
}

# #Terraform state backend 
# terraform {
#    backend "s3" {
#      bucket         = "eks-s3-backend-with-locking"
#      key            = "tfstate/terraform.tfstate"
#      region         = var.region
#      dynamodb_table = "eks-s3-backend-locking"
#      encrypt        = true
#    }
# }

# Module EKS cluster
module "eks_cluster_dev" {
  source                  = "../module_eks"
  region                  = var.region
  cluster_name            = var.cluster_name
  cidr_block              = var.cidr_block
  private_subnet          = var.private_subnet
  public_subnet           = var.public_subnet
  cluster_version         = var.cluster_version
  spot_price              = var.spot_price
  desired_capacity        = var.desired_capacity
  max_size                = var.max_size
  min_size                = var.min_size
  on_demand_base          = var.on_demand_base
  on_demand_percentage    = var.on_demand_percentage
  instance_type           = var.instance_type
  instance_types          = var.instance_types
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
  vpn_ip                  = var.vpn_ip
  account                 = var.account
}