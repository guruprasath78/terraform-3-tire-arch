resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id
  tags = {
    Name="${var.environment}-security-group-private"
  }
}
resource "aws_security_group_rule" "sg_rules" {
  security_group_id = aws_security_group.sg.id
  for_each = var.security-rules
  type = each.value["type"]
  to_port = each.value["to_port"]
  protocol = each.value["protocol"]
  from_port = each.value["from_port"]
  ipv6_cidr_blocks = try(each.value["ipv6_cidr_blocks"],null)
  source_security_group_id = try(each.value["source_security_group_id"],null)
  cidr_blocks = try(each.value["cidr_blocks"],null)
}
