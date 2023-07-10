provider "kubernetes" {
#  load_config_file       = "false"
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "eks-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks-cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "eks-cluster"
  cluster_version = "1.27"

  subnet_ids = module.eks-vpc.private_subnets
  vpc_id     = module.eks-vpc.vpc_id

  tags = {
    environment = "development"
    application = "eks-cluster-app"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.micro"]
    }
  }


  #  worker_groups = [
  #
  #    {
  #      instance_type        = "t2.small"
  #      name                 = "worker-group-1"
  #      asg_desired_capacity = 2
  #    },
  #
  #    {
  #      instance_type        = "t2.micro"
  #      name                 = "worker-group-2"
  #      asg_desired_capacity = 2
  #    }

  #  ]

}