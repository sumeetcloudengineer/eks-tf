provider "aws" {
  region = "ap-south-1"
}

data "aws_availability_zones" "azs" {

}

module "eks-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks-cluster-vpc"
  cidr = "192.168.0.0/16"

  azs             = data.aws_availability_zones.azs.names
  private_subnets = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
  public_subnets  = ["192.168.110.0/24", "192.168.120.0/24", "192.168.130.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"            = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }

}