output "user_script" {
  value = var.user_data
}
output "instance_ids" {
  value = [for instance in aws_instance.instance:instance.id]
}
output "security_group_id" {
  value = aws_security_group.sg.id
}