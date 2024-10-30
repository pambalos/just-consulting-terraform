terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

locals {

}

resource "aws_db_subnet_group" "core_db" {
  subnet_ids = var.public_subnet_ids
  name       = "core-db-subnet-group"
}

resource "aws_security_group" "core_db" {
  name        = "core-db"
  description = "Allow traffic to core-db"
  vpc_id      = var.vpc_id

  tags = {
    Name = "core-db-public-sg"
  }
}

#resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#  security_group_id = aws_security_group.core_db.id
#  cidr_ipv4         = var.vpc_cidr
#  from_port         = 443
#  ip_protocol       = "tcp"
#  to_port           = 443
#}

#resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
#  security_group_id = aws_security_group.core_db.id
#  cidr_ipv6         = aws_vpc.main.ipv6_cidr_block
#  from_port         = 443
#  ip_protocol       = "tcp"
#  to_port           = 443
#}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.core_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.core_db.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.core_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.core_db.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_db_instance" "core_db" {
  identifier = "core-db"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  engine = "postgres"
  engine_version = "14.10"

  db_name = "core"

  username = "SanityAdmin"
  password = "San1tyAdm1n1231!"

  db_subnet_group_name = aws_db_subnet_group.core_db.name
  vpc_security_group_ids = [aws_security_group.core_db.id]

  parameter_group_name = aws_db_parameter_group.core_db.name
  publicly_accessible = true
  skip_final_snapshot = true
}

resource "aws_db_parameter_group" "core_db" {
  name   = "core-db"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}