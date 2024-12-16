#common
environment = "lb-rds"
region = "us-east-1"

#network
vpc_cidr = "10.0.0.0/16"
public_subet = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
private_subnet = [ "10.0.4.0/24","10.0.5.0/24","10.0.6.0/24" ]

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
  },
  # {
  #   name="3",
  #   instance_type="t2.micro",
  #   ami="ami-066784287e358dad1"
  # },{
  #   name="4",
  #   instance_type="t2.micro",
  #   ami="ami-066784287e358dad1"
  # }
  ]
public_instances = [ {
    name="1",
    instance_type="t2.micro",
    ami="ami-066784287e358dad1",
    bastion = true
  }  
  ]
  public-security-rules = {
  allow-all-ipv4-in={
    type="ingress"
    from_port="80"
    to_port="80"
    protocol="tcp"
     cidr_blocks=["0.0.0.0/0"]
    ipv6_cidr_blocks=[]
  }
  allow-my-ipv4={
    type="ingress"
    from_port="22"
    to_port="22"
    protocol="tcp"
    cidr_blocks=["myip"]
    ipv6_cidr_blocks=[]
  }
  allow-aws={
    type="ingress"
    from_port="22"
    to_port="22"
    protocol="tcp"
    cidr_blocks=["18.206.107.24/29"]
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
}
private-security-rules = {
  # allow-all-ipv={
  #   type="ingress"
  #   from_port="22"
  #   to_port="22"
  #   protocol="tcp"
  #   cidr_blocks=[]
  #   ipv6_cidr_blocks=[]
  #   source_security_group_id="bastion"
  # }
  # allow-all-ipv4={
  #   type="ingress"
  #   from_port="80"
  #   to_port="80"
  #   protocol="tcp"
  #   cidr_blocks=[]
  #   ipv6_cidr_blocks=[]
  #   source_security_group_id="bastion"
  # } 
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
  instance_class = "db.t3.medium"},
  {name = "reader",
  type = "reader"
  instance_class = "db.t3.medium"}

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
    cidr_blocks=["0.0.0.0/0"]
  }
}

#iam
 roles={
    ssmbygp={
    Effect="Allow",
    Service="ec2.amazonaws.com"
    managed_policy_arns=["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    },
  }