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
variable "environment" {
  type = string
}