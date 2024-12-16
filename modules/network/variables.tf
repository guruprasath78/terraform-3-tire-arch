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
  default = null
}
variable "nat_ssm_role" {
  type = string
}
variable "nacl_public_rule" {
  type = map(list(map(string)))
}

variable "nacl_private_rule" {
  type = map(list(map(string)))
}