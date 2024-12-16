locals {
  endpoint= [for i in aws_rds_cluster_instance.rds: i.endpoint if i.writer]
}
output "endpoint" {
  value = local.endpoint[0]
}
output "rds_access_sg_id" {
  value = aws_security_group.rds-sg.id
}