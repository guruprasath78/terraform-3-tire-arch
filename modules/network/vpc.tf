resource "aws_vpc" "vpc_kp" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name="${var.environment}-vpc"
  }
}

