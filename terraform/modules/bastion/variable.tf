variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to launch. Example: t2.small"
  default = "t3.small"
}
variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable security_groups {
  type = list(string)
  default = ["default"]
}
variable "subnet_id" {
  type = string
}
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" : "ami-0fa377108253bf620" #Ubuntu 20.04 Jammy
  }
}