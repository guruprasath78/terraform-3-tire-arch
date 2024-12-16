variable "subnet_ids" {
  type = list(string)
}
variable "environment" {
  type = string 
}
variable "availability_zones" {
  type = list(string)
}
variable "cluster_identifier" {
  type = string
  default = null
}
variable "cluster_identifier_prefix" {
  type = string
  default = null
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
  sensitive = true
}
variable "db_password" {
  type = string
  sensitive = true
  validation {
    condition = length(var.db_password)>7
    error_message = "password must be containing 8 characters"
  }
}

variable "cluster_instances" {
  type = list(object({
    name=string
    instance_class=string
    promotion_tier=number
  }))
}
variable "vpc_id" {
  type = string
}
variable "publicly_accessible" {
  type = bool
}
variable "port" {
  type = number
  default = 3306
}