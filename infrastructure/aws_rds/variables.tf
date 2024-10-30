#variable "db_subnet_group_name" {
#    description = "The name of the DB subnet group."
#    type        = string
#}

#variable "db_security_group_id" {
#    description = "The ID of the security group to associate with the DB instance."
#    type        = string
#}

variable "public_subnet_ids" {
    description = "The IDs of the subnets in which to place the RDS instance."
    type        = list(string)
}

variable "vpc_id" {
    description = "The ID of the VPC in which to place the RDS instance."
    type        = string
}

variable "vpc_cidr" {
    description = "The CIDR block of the VPC in which to place the RDS instance."
    type        = string
}