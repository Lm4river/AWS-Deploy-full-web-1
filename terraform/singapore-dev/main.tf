terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#Create a complete VPC using module networking
module "networking" {
  source              = "../modules/networking"
  region              = var.region
  availability_zones  = var.availability_zones
  cidr_block          = var.cidr_block
  public_subnet_ips   = var.public_subnet_ips
  private_subnet_ips  = var.private_subnet_ips
}

module "security" {
  source = "../modules/security"
  region = var.region
  vpc_id = module.networking.vpc_id
}

module "bastion" {
  source = "../modules/bastion"
  region = var.region
  instance_type = "t3.small"
  security_groups = [
    module.security.bastion_security_group_id
  ]
  subnet_id = module.networking.public_subnet_ids[0]
}

module "database"{
  source = "../modules/database"
  region = var.region
  vpc_id = module.networking.vpc_id
  db_subnets = module.networking.private_subnet_ids
  db_security_group_ids = [
    module.security.database_security_group_id
  ]
  db_username = var.db_username
}
module "load_balance" {
  source                 = "../modules/load_balance"
  region                 = var.region
  vpc_id                 = module.networking.vpc_id
  load_balance_subnet_ids = module.networking.public_subnet_ids
  load_balance_security_group_ids = [
    module.security.public_security_group_id
  ]
}

module "ecs_cluster"{
  source = "../modules/ecs_cluster"
  region = var.region
  vpc_id = module.networking.vpc_id
  ecs_subnet_ids = module.networking.private_subnet_ids
  ecs_security_group_ids = [
    module.security.private_security_group_id
  ]
  alb_arn = module.load_balance.alb_arn
  frontend_target_group_arn = module.load_balance.frontend_target_group_arn
  frontend_ecr_image_url = var.frontend_ecr_repo_url
  backend_target_group_arn = module.load_balance.backend_target_group_arn
  backend_ecr_image_url = var.backend_ecr_repo_url
  alb_dns = "http://${module.load_balance.alb_dns}:80"
  mongodb_connection_string_secret_arn = module.database.mongodb_connection_string_secret_arn
}
