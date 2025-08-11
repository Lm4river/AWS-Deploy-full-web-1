variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "vpc_id" {
  type = string
  description = "The VPC ID to ALB and Target Group"
  nullable = false
}

variable "ecs_subnet_ids" {
  type = list(string)
  description = "The subnet IDs to launch ECS Service"
  nullable = false  
}

variable "ecs_security_group_ids" {
  type = list(string)
  nullable = false
}
variable "alb_arn" {
  type = string
  description = "The ARN of the Application Load Balancer"
  nullable = false
}
variable "frontend_target_group_arn" {
  type = string
  description = "The ARN of the target group for the Frontend ECS Service"
  nullable = false
}
variable "frontend_ecr_image_url" {
  type = string
  description = "The URI of the ECR repository for the Node.js application"
  nullable = false
}

variable "backend_target_group_arn" {
  type = string
  description = "The ARN of the target group for the ECS Service"
  nullable = false
}
variable "backend_ecr_image_url" {
  type = string
  description = "The URI of the ECR repository for the Node.js application"
  nullable = false
}

variable "alb_dns" {
  type = string
  nullable = false
}

variable mongodb_connection_string_secret_arn{
  type = string
  description = "The ARN of the MongoDB connection string secret"
  nullable = false
}