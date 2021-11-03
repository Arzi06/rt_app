
# VPC
variable "region" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable cidr_block {
  type    = string
}
variable private_subnet {
  type    = list
}
variable public_subnet {
  type    = list
}

# Cluster
variable cluster_version {
  type    = string
}

# Autoscaling group
variable instance_type {
  type    = string
}
variable spot_price {
  type    = string
}
variable desired_capacity {
  type    = string
}
variable max_size {
  type    = string
}
variable min_size {
  type    = string
}
variable instance_types {
  type    = list
}

variable "shared_credentials_file" {
  type = string
}

variable "profile" {
  type = string
}

variable "vpn_ip" {}

variable "account" {}

variable "on_demand_base" {}

variable "on_demand_percentage" {}