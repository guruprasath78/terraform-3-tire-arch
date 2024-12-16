output "private_user_script" {
  value = var.private_user_script
}
output "private_instances" {
  value = [for instance in aws_instance.private:instance.id]
}
output "private_security_groups" {
  value = aws_security_group.sg-pri.id
}