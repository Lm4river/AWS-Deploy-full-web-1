variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "vpc_id" {
  type = string
  description = "The VPC ID"
  nullable = false
  
}
variable "db_subnets" {
  type = list(string)
  description = "The Subnet Group that deploy MongoDB"
  nullable = false
}
variable "db_security_group_ids" {
  type = list(string)
  description = "The Security Group IDs apply for database"
  nullable = false
}
variable "db_username" {
  type = string
  description = "Admin Username for the database"
  nullable = false
  default = "udemy_admin"
}