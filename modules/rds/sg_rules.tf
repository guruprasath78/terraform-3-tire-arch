
locals {
  
  sg_rules=[
    {
  to_port = var.port
  from_port = var.port
  protocol = "tcp"
  type = "ingress"
  self=true
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