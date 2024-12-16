#network
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


#instances
variable "public-security-rules" {
  type=map(any)
}
variable "private-security-rules" {
  type = map(any)
}
variable "public_instances" {
  type = list(object({
    name=string
    instance_type=string
    ami=string
    bastion=bool
  }))
}
variable "private_instances" {
  type = list(object({
    name=string
    instance_type=string
    ami=string
  }))
}

#rds
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
  # sensitive = true
}
variable "db_password" {
  type = string
  # sensitive = true
  validation {
    condition = length(var.db_password)>7
    error_message = "password must be containing 8 characters"
  }
}
variable "cluster_instances" {
  type = list(object({
    name=string
    instance_class=string
    type=string
  }))
  validation {
    condition = alltrue([
      for instance in var.cluster_instances : (
        instance.type == "writer" || instance.type == "reader"
      )
    ])
    error_message = "Each instance 'type' must be either 'writer' or 'reader'."
  }
}

#alb
variable "lb_sg_rules" {
  type = map(object({
    to_port = number
  from_port = number
  type = string
  protocol = string
  cidr_blocks = list(string)
  }))
}


variable "region" {
  type = string
}

#iam
variable "roles" {
  type = map(object({
    Effect=string
    Service=string
    managed_policy_arns=list(string)
  }))
   validation {
    condition = alltrue([
      for role in var.roles : contains(["Allow","Deny"],role.Effect)
    ])
    error_message = "The 'Effect' attribute must be either 'Allow' or 'Deny'."
  }
}