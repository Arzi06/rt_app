
###############        Worker IAM Role        ################# 

resource "aws_iam_role" "worker" {
  name               = "${var.cluster_name}_worker"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_policy" "ecr_full_access" {
  name        = "ecr_full_access"
  description = "policy_full_ecr_access"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = aws_iam_policy.ecr_full_access.arn
  role       = aws_iam_role.worker.name
  depends_on = [
    aws_iam_policy.ecr_full_access
  ]
}

resource "aws_iam_instance_profile" "worker" {
  name       = "${var.cluster_name}_worker"
  role       = aws_iam_role.worker.name
}

###############        Worker Security Group        #################

resource "aws_security_group" "worker" {
  name        = "${var.cluster_name}_worker_nodes"
  description = "Security group for all worker_nodes in the cluster"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags                                          = {
    Name                                        = "${var.cluster_name}_worker_nodes"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cluster_https" {
  description              = "Allow worker to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.eks.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cluster_others" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.eks.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks.id
  source_security_group_id = aws_security_group.worker.id
  to_port                  = 443
  type                     = "ingress"
}


###############        Worker Nodes        #################

data "aws_ami" "eks_worker" {  # AMI image for worker nodes
filter {
  name   = "name"
  values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
 }

 most_recent = true
 owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_template" "worker" {
  iam_instance_profile {
    name = aws_iam_instance_profile.worker.name
  }
  image_id                    = data.aws_ami.eks_worker.id
  instance_type               = var.instance_type
  name_prefix                 = "${var.cluster_name}_launch_template"
  vpc_security_group_ids      = [aws_security_group.worker.id]
  user_data                   = base64encode(local.node-userdata)

  lifecycle {
   create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "workers" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.cluster_name}_autoscaling_group"
  vpc_zone_identifier  = aws_subnet.private.*.id

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base
      on_demand_percentage_above_base_capacity = var.on_demand_percentage # this means everything else will be 80% spot and 20% onDemand (we have fixed capacity of 1 onDemand)
      spot_allocation_strategy                 = "lowest-price"
      spot_max_price                           = var.spot_price
    }

    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.worker.id}"
      }

      override {
        instance_type     = var.instance_types[0]
      }
      override {
        instance_type     = var.instance_types[1]
      }
      override {
        instance_type     = var.instance_types[2]
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "TRUE"
    propagate_at_launch = true
  }
}