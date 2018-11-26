variable "tags" { type = "map" }

variable "public_subnet1_cidr_block" {}
variable "public_subnet2_cidr_block" {}
variable "private_subnet1_cidr_block" {}
variable "private_subnet2_cidr_block" {}

variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr_block" {}

variable "amis" { type = "map" }
variable "instance_types" { type = "map" }

variable "asg_min_size" {}
variable "asg_max_size" {}

variable "office_cidrs" {}