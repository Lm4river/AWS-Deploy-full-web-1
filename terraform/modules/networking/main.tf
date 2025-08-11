# Create VPC
# Sử dụng module VPC có sẵn của terraform để tạo VPC cho nhanh (thay vì tạo từng thành phần VPC, subnet, route table, internet gateway, ...)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "Udemy DevOps"
  cidr = var.cidr_block

  azs             = var.availability_zones
  public_subnets  = var.public_subnet_ips
  private_subnets = var.private_subnet_ips

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true
  tags = {
    Name = "Udemy DevOps"
  }
}

# Create subnet group for MongoDB
resource "aws_docdb_subnet_group" "mongodb_subnet_group" {
  subnet_ids = module.vpc.private_subnets
  name       = "udemy-mongodb-subnet-group"
}