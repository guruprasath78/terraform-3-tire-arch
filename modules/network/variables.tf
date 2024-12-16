variable "vpc_cidr" {
  type = string
}
variable "public_subet" {
  type = list(string)
}
variable "private_subnet" {
  type=list(string)
}
variable "environment" {
  type = string

}
variable "nat_type" {
  type = string
  validation {
    condition = contains(["gateway","instance"],var.nat_type)
    error_message = "Invalid input only \"gateway\" or \"instance\" is accepted"
  }
}
variable "nat_instance_rules" {
  type = map(any)
  default = {
    allow-all-ipv4-in={
    type="ingress"
    from_port="80"
    to_port="80"
    protocol="tcp"
     cidr_blocks=["0.0.0.0/0"]
    ipv6_cidr_blocks=[]
  }
  allow-https-ipv4-in={
    type="ingress"
    from_port="443"
    to_port="443"
    protocol="tcp"
     cidr_blocks=["0.0.0.0/0"]
    ipv6_cidr_blocks=[]
  }
  allow-aws={
    type="ingress"
    from_port="22"
    to_port="22"
    protocol="tcp"
    cidr_blocks=["3.16.146.0/29"]
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
}