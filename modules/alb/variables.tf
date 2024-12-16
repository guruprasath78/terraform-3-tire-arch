variable "environment" {
  type = string
}
variable "security_group_ids" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "instance_ids" {
  type = list(string)
}
variable "target_group_config" {
  type = map(any)
}
variable "lb_sg_rules" {
  type = map(object({
    to_port = number
  from_port = number
  type = string
  protocol = string
  cidr_blocks = list(string)
  }))
}