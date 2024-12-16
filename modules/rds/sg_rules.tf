
locals {
  
  sg_rules=[
    {
  to_port = var.port
  from_port = var.port
  protocol = "tcp"
  type = "ingress"
  source_security_group_id="${aws_security_group.access-to-rds.id}"
    },
    {
  to_port = 0
  from_port = 0
  protocol = "-1"
  type = "egress"
  cidr_blocks=["0.0.0.0/0"]
    },
    {
  to_port = var.port
  from_port = var.port
  protocol = "tcp"
  type = "ingress"
  cidr_blocks=["0.0.0.0/0"]
    }
  ] 
}