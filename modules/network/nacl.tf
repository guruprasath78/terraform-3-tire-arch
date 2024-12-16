resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.this.id
  subnet_ids = local.pub_sub_ids
  tags = {
    Name="${var.environment}-public-nacl"
  }
}
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id
  subnet_ids = local.pri_sub_ids
  tags = {
    Name="${var.environment}-private-nacl"
  }
}
resource "aws_network_acl_rule" "public-inbound" {
    count = length(var.nacl_public_rule["inbound"])
  network_acl_id = aws_network_acl.public.id
  rule_number    = var.nacl_public_rule["inbound"][count.index]["rule_number"]
  egress         = false
  protocol       = var.nacl_public_rule["inbound"][count.index]["protocol"]
  rule_action    = var.nacl_public_rule["inbound"][count.index]["rule_action"]
  cidr_block     = try(var.nacl_public_rule["inbound"][count.index]["cidr_block"],null)
  ipv6_cidr_block =try(var.nacl_public_rule["inbound"][count.index]["ipv6_cidr_block"],null)
  from_port      = var.nacl_public_rule["inbound"][count.index]["from_port"]
  to_port        = var.nacl_public_rule["inbound"][count.index]["to_port"] 
}
resource "aws_network_acl_rule" "public-outbound" {
    count = length(var.nacl_public_rule["outbound"])
  network_acl_id = aws_network_acl.public.id
  egress         = true
  rule_number    = var.nacl_public_rule["outbound"][count.index]["rule_number"]
  protocol       = var.nacl_public_rule["outbound"][count.index]["protocol"]
  rule_action    = var.nacl_public_rule["outbound"][count.index]["rule_action"]
  cidr_block     = try(var.nacl_public_rule["outbound"][count.index]["cidr_block"],null)
  ipv6_cidr_block =try(var.nacl_public_rule["outbound"][count.index]["ipv6_cidr_block"],null)
  from_port      = var.nacl_public_rule["outbound"][count.index]["from_port"]
  to_port        = var.nacl_public_rule["outbound"][count.index]["to_port"] 
}

resource "aws_network_acl_rule" "private-inbound" {
    count = length(var.nacl_private_rule["inbound"])
  network_acl_id = aws_network_acl.private.id
  rule_number    = var.nacl_private_rule["inbound"][count.index]["rule_number"]
  egress         = false
  protocol       = var.nacl_private_rule["inbound"][count.index]["protocol"]
  rule_action    = var.nacl_private_rule["inbound"][count.index]["rule_action"]
  cidr_block     = try(var.nacl_private_rule["inbound"][count.index]["cidr_block"],null)
  ipv6_cidr_block =try(var.nacl_private_rule["inbound"][count.index]["ipv6_cidr_block"],null)
  from_port      = var.nacl_private_rule["inbound"][count.index]["from_port"]
  to_port        = var.nacl_private_rule["inbound"][count.index]["to_port"] 
}
resource "aws_network_acl_rule" "private-outbound" {
    count = length(var.nacl_private_rule["outbound"])
  network_acl_id = aws_network_acl.private.id
  rule_number    = var.nacl_private_rule["outbound"][count.index]["rule_number"]
  egress         = true
  protocol       = var.nacl_private_rule["outbound"][count.index]["protocol"]
  rule_action    = var.nacl_private_rule["outbound"][count.index]["rule_action"]
  cidr_block     = try(var.nacl_private_rule["outbound"][count.index]["cidr_block"],null)
  ipv6_cidr_block =try(var.nacl_private_rule["outbound"][count.index]["ipv6_cidr_block"],null)
  from_port      = var.nacl_private_rule["outbound"][count.index]["from_port"]
  to_port        = var.nacl_private_rule["outbound"][count.index]["to_port"] 
}

