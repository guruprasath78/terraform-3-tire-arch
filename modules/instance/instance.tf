# #public instance or bastion
# resource "aws_instance" "public" {
#   count = length(var.public_instances)
#   instance_type = var.public_instances[count.index].instance_type
#   ami = var.public_instances[count.index].ami
#   key_name = aws_key_pair.generated_key.key_name
#   user_data = var.public_instances[count.index].bastion?local.user_data:null
#   vpc_security_group_ids =var.public_instances[count.index].bastion?[aws_security_group.sg-bas.id]:[aws_security_group.sg-pub.id]
#   subnet_id = (length(var.public_subnets) > 0 
#     ? var.public_subnets[count.index%length(var.public_subnets)]
#     : null)
#     tags = {
#     Name="${var.environment}-${var.public_instances[count.index].bastion?"bastion":"public"}-${var.public_instances[count.index].name}"
#   }
# }
#private instance
resource "aws_instance" "private" {
  count = length(var.private_instances)
  instance_type = var.private_instances[count.index].instance_type
  user_data_base64 = var.private_user_script
  ami = var.private_instances[count.index].ami
  key_name = aws_key_pair.generated_key.key_name
  vpc_security_group_ids =concat([aws_security_group.sg-pri.id],var.additional_security_groups)
subnet_id =( length(var.private_subnets) > 0 ?var.private_subnets[count.index%length(var.private_subnets)]
    : null)
    tags = {
    Name="${var.environment}-private-${var.private_instances[count.index].name}"
  }
  user_data_replace_on_change = true
  iam_instance_profile = aws_iam_instance_profile.private.name
  lifecycle {
    create_before_destroy = true
  }
  
}
resource "aws_iam_instance_profile" "private" {
  name="${var.iam_role}-instance-profile"
  role = var.iam_role
}