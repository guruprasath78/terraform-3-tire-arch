variable "security-rules" {
  type = map(any)
}
variable "vpc_id" {
  type = string
}
variable "subnets" {
  type = list(any)
}
variable "environment" {
  type = string
}
variable "user_data" {
  type = any
}
variable "instances" {
  type = list(object({
    name=string,
    instance_type=string,
    ami=string,
  }))
}
variable "security_groups_to_attach" {
  type = list(string)
  default = []
}
variable "iam_role" {
  type = string
  default = null
}
variable "key_pair" {
  type = string
  default = null
}