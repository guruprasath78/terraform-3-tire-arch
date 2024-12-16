resource "aws_iam_role" "trusted_role" {
  for_each = var.roles
  name = "${var.environment}-${each.key}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": each.value.Effect,
        "Principal": {
          "Service": each.value.Service
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = each.value.managed_policy_arns
}
output "roles" {
  value = {for i,v in aws_iam_role.trusted_role: i=>v.name}
}