#common
environment = "mtc-final"
region = "us-east-1"

#network
vpc_cidr = "10.0.0.0/16"
public_subet = [ "10.0.1.0/24","10.0.2.0/24" ]
private_subnet = [ "10.0.4.0/24","10.0.5.0/24" ]
#nacl
nacl_public_rule = {
  "inbound" = [
    {
  rule_number    =300
  rule_action    = "allow"
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  },
  #block ips
  {
  rule_number    =250
  rule_action    = "deny"
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "152.58.220.227/32"
  }
  ],
  "outbound" = [
    {
  rule_number    =301
  rule_action    = "allow"
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  }
  #  #block ips
  # {
  # rule_number    =250
  # rule_action    = "deny"
  # protocol       = "-1"
  # from_port      = 0
  # to_port        = 0
  # cidr_block     = "152.58.220.227/32"
  # }
  ]
}
nacl_private_rule = {
  "inbound" = [
    {
  rule_number    =300
  rule_action    = "allow"
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  }
  ],
  "outbound" = [
    {
  rule_number    =301
  rule_action    = "allow"
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  }
  ]
}

#instance
private_instances = [  {
    name="1",
    instance_type="t2.micro",
    ami="ami-066784287e358dad1"
  },
  {
    name="2",
    instance_type="t2.micro",
    ami="ami-066784287e358dad1"
  }
  ]
#   public-security-rules = {
#   allow-all-ipv4-in={
#     type="ingress"
#     from_port="80"
#     to_port="80"
#     protocol="tcp"
#      cidr_blocks=["0.0.0.0/0"]
#     ipv6_cidr_blocks=[]
#   }
#   allow-my-ipv4={
#     type="ingress"
#     from_port="22"
#     to_port="22"
#     protocol="tcp"
#     cidr_blocks=["myip"]
#     ipv6_cidr_blocks=[]
#   }
#   allow-aws={
#     type="ingress"
#     from_port="22"
#     to_port="22"
#     protocol="tcp"
#     cidr_blocks=["18.206.107.24/29"]
#     ipv6_cidr_blocks=[]
#   }
#   allow-all-ipv4-out={
#      type="egress"
#     from_port="0"
#     to_port="0"
#     protocol="-1"
#     cidr_blocks=["0.0.0.0/0"]
#     ipv6_cidr_blocks=[]
#   }
# }
private-security-rules = {
 allow-all-ipv4-out={
     type="egress"
    from_port="0"
    to_port="0"
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    ipv6_cidr_blocks=[]
    source_security_group_id=null
  }
}

#rds
db_name = "guru"
db_username = "superops"
db_password = "tiger123"
cluster_instances =[
  {name = "writer",
  type = "writer"
  instance_class = "db.t3.medium"
  promotion_tier = 1},
  # {name = "reader",
  # type = "reader"
  # instance_class = "db.t3.medium"
  # promotion_tier = 0}

]

#alb
lb_sg_rules = {
  "all_http_in" = {
    to_port=80
    from_port=80
    protocol="tcp"
    type="ingress"
    cidr_blocks=["0.0.0.0/0"]
  }
  "all_http_out" = {
    to_port=80
    from_port=80
    protocol="tcp"
    type="egress"
    cidr_blocks=["10.0.0.0/16"]
  }
}

#iam
 roles={
    ssm={
    Effect="Allow",
    Service="ec2.amazonaws.com"
    managed_policy_arns=["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    },
  }