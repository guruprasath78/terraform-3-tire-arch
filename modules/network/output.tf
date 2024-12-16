output "vpc_id" {
  value = aws_vpc.vpc_kp.id
}
locals {
  # List of public subnet IDs
  pub_sub_ids = aws_subnet.pub_subnet.*.id
  
  # List of private subnet IDs
  pri_sub_ids = aws_subnet.pri_subnet.*.id
}
output "availability_zones" {
  value = data.aws_availability_zones.available.names
}
output "public_subnets_ids" {
  value = local.pub_sub_ids
}
output "private_subnets_ids" {
  value = local.pri_sub_ids
}