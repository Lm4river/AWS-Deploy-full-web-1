variable "region" {
  type = string
  default = "ap-southeast-1"
}

#parameters for networking module
variable "availability_zones" {
  type = list(string)
  nullable = false
}
variable "cidr_block" {
  type = string
  nullable = false
}
variable "public_subnet_ips" {
  type = list(string)
  nullable = false
  
}
variable "private_subnet_ips" {
  type = list(string)
  nullable = false
}

variable "frontend_ecr_repo_url" {
  type = string
  description = "The URI of the ECR repository for the Frontend application"
  nullable = false
}
variable "backend_ecr_repo_url" {
  type = string
  description = "The URI of the ECR repository for the Backend application"
  nullable = false
}
variable "db_username" {
  type = string
  description = "Admin Username for the database"
  nullable = false
  default = "udemy"
}