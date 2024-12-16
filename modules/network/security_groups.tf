
resource "aws_security_group" "sg-nat" {
  count = var.nat_type=="instance"?1:0
  vpc_id = aws_vpc.vpc_kp.id
  tags = {
    Name="${var.environment}-security-group-nat-instance"
  }
}

resource "aws_security_group_rule" "sg-nst_rule" {
  security_group_id = aws_security_group.sg-nat[0].id
  for_each = local.nat_rules
  type = each.value["type"]
  to_port = each.value["to_port"]
  protocol = each.value["protocol"]
  from_port = each.value["from_port"]
  cidr_blocks = each.value["cidr_blocks"]
}
locals {
  nat_rules=var.nat_type=="instance"?{
    allow-http={
    type="ingress"
    from_port="80"
    to_port="80"
    protocol="tcp"
     cidr_blocks=[var.vpc_cidr]
    ipv6_cidr_blocks=[]
  }
  allow-aws-ssh={
    type="ingress"
    from_port="22"
    to_port="22"
    protocol="tcp"
    cidr_blocks=["3.16.146.0/29"]
    ipv6_cidr_blocks=[]
  }
  allow-https={
    type="ingress"
    from_port="443"
    to_port="443"
    protocol="tcp"
     cidr_blocks=[var.vpc_cidr]
    ipv6_cidr_blocks=[]
  }
  allow-icmp={
    type="ingress"
    from_port=-1
    to_port=-1
    protocol="ICMP"
     cidr_blocks=[var.vpc_cidr]
    ipv6_cidr_blocks=[]
  }
  allow-all-ipv4-out={
     type="egress"
    from_port="0"
    to_port="0"
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    ipv6_cidr_blocks=[]
  }
  }:{}
}
