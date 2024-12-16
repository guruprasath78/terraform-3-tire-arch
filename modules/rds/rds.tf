resource "aws_db_subnet_group" "name" {
  subnet_ids = var.subnet_ids
  name = "${var.environment}-subnet-group"
  tags = {
    Name="${var.environment}-subnet-group"
  }
}
resource "aws_rds_cluster" "rds" {
  engine = "aurora-mysql"
  cluster_identifier =var.cluster_identifier!=null?"${var.environment}-cluster-${var.cluster_identifier}-":null
  cluster_identifier_prefix = var.cluster_identifier_prefix!=null?"${var.environment}-cluster-${var.cluster_identifier_prefix}-":null
  iam_database_authentication_enabled = true
  port = var.port
  apply_immediately = true
  db_subnet_group_name = aws_db_subnet_group.name.name
  availability_zones = var.availability_zones
  database_name = var.db_name
  master_username = var.db_username
  master_password = var.db_password
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
}
resource "aws_rds_cluster_instance" "rds" {
  apply_immediately = true
  count = length(var.cluster_instances)
  identifier = var.cluster_instances[count.index]["name"]
  cluster_identifier = aws_rds_cluster.rds.id
  instance_class = var.cluster_instances[count.index]["instance_class"]
  engine = aws_rds_cluster.rds.engine
  promotion_tier = var.cluster_instances[count.index]["type"]=="writer"?1:0
  publicly_accessible = var.publicly_accessible
}
resource "aws_security_group" "rds-sg" {
  vpc_id = var.vpc_id
  tags = {
    Name="${var.environment}-rds-sg-access"
  }
}
resource "aws_security_group_rule" "rds-sg" {
  count = var.publicly_accessible?3:2
  security_group_id = aws_security_group.rds-sg.id
  to_port = local.sg_rules[count.index].to_port
  from_port = local.sg_rules[count.index].from_port
  protocol = local.sg_rules[count.index].protocol
  type = local.sg_rules[count.index].type
  source_security_group_id = try(local.sg_rules[count.index].security_group_id,null)
  cidr_blocks = try(local.sg_rules[count.index].cidr_blocks,null)
  self = try(local.sg_rules[count.index].self,null)
}