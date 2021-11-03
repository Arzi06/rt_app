
###############        EKS cluster       #################

resource "aws_security_group" "eks" {
  name          = "${var.cluster_name}_cluster"
  description   = "Allows the communucation with the worker nodes"
  vpc_id        = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ControlPlaneSecurityGroup"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
# to the Kubernetes. You will need to replace A.B.C.D below with
# your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = var.vpn_ip
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks.id
  to_port           = 443
  type              = "ingress"
}


resource "aws_iam_role" "eks" {
  name               = "${var.cluster_name}_cluster"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_cluster" "eks" {

  name                 = "${var.cluster_name}"
  role_arn             = aws_iam_role.eks.arn
  version              = var.cluster_version

  vpc_config {
    subnet_ids         = aws_subnet.private.*.id
    security_group_ids = [aws_security_group.eks.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    "kubernetes.io/role/elb"                    = 1,
  }
}