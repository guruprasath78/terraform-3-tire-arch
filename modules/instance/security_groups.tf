# resource "aws_security_group" "sg-pub" {
#   vpc_id = var.vpc_id
#   tags = {
#     Name="${var.environment}-security-group-public"
#   }
# }
# resource "aws_security_group" "sg-bas" {
#   vpc_id = var.vpc_id
#   tags = {
#     Name="${var.environment}-security-group-bastion"
#   }
# }
resource "aws_security_group" "sg-pri" {
  vpc_id = var.vpc_id
  tags = {
    Name="${var.environment}-security-group-private"
  }
}


# resource "aws_security_group_rule" "sg-pub_rule" {
#   security_group_id = aws_security_group.sg-pub.id
#   for_each = var.public-security-rules
#   type = each.value["type"]
#   to_port = each.value["to_port"]
#   protocol = each.value["protocol"]
#   from_port = each.value["from_port"]
#   cidr_blocks = each.value["cidr_blocks"][0]=="myip"?["${chomp(data.http.myip.response_body)}/32"]:each.value["cidr_blocks"]
# }
# resource "aws_security_group_rule" "sg-bas_rule" {
#   security_group_id = aws_security_group.sg-bas.id
#   for_each = var.public-security-rules
#   type = each.value["type"]
#   to_port = each.value["to_port"]
#   protocol = each.value["protocol"]
#   from_port = each.value["from_port"]
#   cidr_blocks = each.value["cidr_blocks"][0]=="myip"?["${chomp(data.http.myip.response_body)}/32"]:each.value["cidr_blocks"]
# }
resource "aws_security_group_rule" "sg-pri_rules" {
  security_group_id = aws_security_group.sg-pri.id
  for_each = var.private-security-rules
  type = each.value["type"]
  to_port = each.value["to_port"]
  protocol = each.value["protocol"]
  from_port = each.value["from_port"]
  ipv6_cidr_blocks = each.value["source_security_group_id"]=="bastion"?null:each.value["ipv6_cidr_blocks"]
  # source_security_group_id = each.value["source_security_group_id"]=="bastion"?aws_security_group.sg-bas.id:null
  cidr_blocks = each.value["source_security_group_id"]=="bastion"?null:each.value["cidr_blocks"]  
}
