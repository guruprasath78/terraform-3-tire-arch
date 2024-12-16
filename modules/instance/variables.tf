# variable "public-security-rules" {
#   type=map(any)
# }
variable "private-security-rules" {
  type = map(any)
}
variable "vpc_id" {
  type = string
}
# variable "public_subnets" {
#   type = list(any)
# }
variable "private_subnets" {
  type = list(any)
}
variable "environment" {
  type = string
}
variable "private_user_script" {
  type = any
  description = "this user_script executed only on private instances"
}
# variable "public_instances" {
#   type = list(object({
#     name=string,
#     instance_type=string,
#     ami=string,
#     bastion=bool
#   }))
# }
variable "private_instances" {
  type = list(object({
    name=string,
    instance_type=string,
    ami=string,
  }))
}
variable "additional_security_groups" {
  type = list(string)
  default = []
}
variable "iam_role" {
  type = string
  default = null
}