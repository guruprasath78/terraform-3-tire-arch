resource "aws_lb_target_group" "target_group" {
  vpc_id = var.target_group_config["vpc_id"]
  port = var.target_group_config["port"]
  health_check {
    healthy_threshold = try(var.target_group_config["healthy_threshold"],null)
    unhealthy_threshold = try(var.target_group_config["unhealthy_threshold"],null)
  }
  name = "${var.environment}-target-group"
  protocol = var.target_group_config["protocol"]
  target_type = var.target_group_config["target_type"]
  tags = {
    Name="${var.environment}-target-group"
  }
}
resource "aws_lb_target_group_attachment" "add" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = var.instance_ids[count.index]
}

resource "aws_lb" "load_balancer" {
  load_balancer_type = "application"
  name="${var.environment}-loadbalancer"
  security_groups = [aws_security_group.lb-sg.id]
  subnets = var.public_subnets
  internal = false
  tags = {
    Name="${var.environment}-lb"
  }
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = var.target_group_config["port"]
  protocol = var.target_group_config["protocol"]
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
resource "aws_security_group" "lb-sg" {
  vpc_id =var.target_group_config["vpc_id"]
  tags = {
    Name="${var.environment}-lb-sg"
  }
}
resource "aws_security_group_rule" "lb_ingress" {
  for_each = var.lb_sg_rules
  security_group_id = aws_security_group.lb-sg.id
  to_port = each.value["to_port"]
  from_port = each.value["from_port"]
  type = each.value["type"]
  protocol = each.value["protocol"]
  cidr_blocks = each.value["cidr_blocks"]
}
resource "aws_security_group_rule" "lb-to-instance" {
  count=length(var.security_group_ids)
  security_group_id = var.security_group_ids[count.index]
  to_port = var.target_group_config["port"]
  from_port = var.target_group_config["port"]
  type = "ingress"
  protocol = "tcp"
  source_security_group_id = aws_security_group.lb-sg.id
}