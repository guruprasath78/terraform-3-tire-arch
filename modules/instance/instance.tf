resource "aws_instance" "instance" {
  count = length(var.instances)
  instance_type = var.instances[count.index].instance_type
  user_data_base64 = var.user_data
  ami = var.instances[count.index].ami
  key_name = var.key_pair
  vpc_security_group_ids =concat([aws_security_group.sg.id],var.security_groups_to_attach)
subnet_id =( length(var.subnets) > 0 ?var.subnets[count.index%length(var.subnets)]
    : null)
    tags = {
    Name="${var.environment}-private-${var.instances[count.index].name}"
  }
  user_data_replace_on_change = true
  iam_instance_profile = try(aws_iam_instance_profile.private[0].name)
  lifecycle {
    create_before_destroy = true
  }
  
}
resource "aws_iam_instance_profile" "private" {
  count = var.iam_role!=null?1:0
  name="${var.iam_role}-instance-profile"
  role = var.iam_role
}