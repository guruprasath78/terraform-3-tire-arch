# resource "aws_autoscaling_group" "name" {
#   name = "${var.environment}-asg"
#   max_size = 2
#   min_size = 1
#   desired_capacity = 2
#   vpc_zone_identifier = var.private_subnets_ids
#   launch_template {
#     id = aws_launch_template.launch_template.id
#   }
# }
# resource "aws_autoscaling_attachment" "name" {
#   autoscaling_group_name = aws_autoscaling_group.name.name
#   elb = aws_lb.asg.name
# }
# resource "aws_launch_template" "launch_template" {
#   name_prefix   = "foobar"
#   image_id      = "ami-066784287e358dad1"
#   instance_type = "t2.micro"
# }
# resource "aws_lb" "asg" {
#   load_balancer_type = "application"
#   name="${var.environment}-lb-asg-${var.lb_name}"
#   security_groups = [aws_security_group.name.id]
#   subnets = var.public_subnets
#   internal = false
#   tags = {
#     Name="${var.environment}-lb"
#   }
# }