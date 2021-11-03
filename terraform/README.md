# EKS - directory consists of:

`\terraform` - contains terraform files to create VPC components, EKS cluster with worker nodes, and S3 bucket

`\Makefile`

#### Used Documentation:
- https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

### Instruction for Makefile: run the following commands in turn to create the EKS cluster

1. `make create_S3` - create a DynamoDB locked S3 bucket that will hold the ".tfstate" file

2. `make init` - initialize a working directory containing Terraform configuration files

3. `make apply` - create : VPC components, EKS cluster with worker nodes and attach the workers to the master node

### For deleting:

- `make rm_S3` - **delete everything that was created in step 1**

- `make destroy` - **delete everything that was created in step 3**
