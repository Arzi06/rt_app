
###############        VPC        ##################

resource "aws_vpc" "vpc" {

  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                                           = {
    Name                                         = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}"  = "shared"
  }
}

resource "aws_internet_gateway" "internet_gateway_dev" {

  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "public_rt_dev" {
  
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_dev.id
  }
  tags         = {
    Name       = "${var.cluster_name}"
  }
}

data "aws_availability_zones" "available" {}

 #-----NAT Gateways with Elastic IPs--------------------------

# resource "aws_eip" "nat" {
#   count = 1 #length(var.private_subnet)
#   vpc   = true
#   tags  = merge({ Name = "${var.cluster_name}-nat-eip-${count.index + 1}" })
# }


# resource "aws_nat_gateway" "nat" {
#   count         = 1 #length(var.private_subnet)
#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id 
#   tags          = merge({ Name = "${var.cluster_name}-nat-gw-${count.index + 1}" })
# }

#--------------Private Subnets and Routing-------------------------

resource "aws_subnet" "private" {

  vpc_id                                         = aws_vpc.vpc.id
  count                                          = length(var.private_subnet)
  cidr_block                                     = var.private_subnet[count.index]
  availability_zone                              = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch                        = "false"
  tags                                           = {
     Name                                        = "private_${var.cluster_name}-${count.index +1}"
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# resource "aws_route_table" "private_subnets" {
#   count  = 1 #length(var.private_subnet)
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat[count.index].id
#   }
#   tags = merge({ Name = "${var.cluster_name}-route-private-subnet-${count.index + 1}" })
# }

# resource "aws_route_table_association" "private_routes" {
#   count          = 1 #length(var.private_subnet)
#   route_table_id = aws_route_table.private_subnets[count.index].id
#   subnet_id      = aws_subnet.private[count.index].id
# }

#--------------Public Subnets and Routing-------------------------
resource "aws_subnet" "public" {

  vpc_id                                         = aws_vpc.vpc.id
  count                                          = length(var.public_subnet)
  cidr_block                                     = var.public_subnet[count.index]
  availability_zone                              = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch                        = "true"
  tags                                           = {
     Name                                        = "public_${var.cluster_name}-${count.index +1}"
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public" {

  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public_rt_dev.id
}