module "network" {
  source         = "./modules/network"
  vpc_cidr       = var.vpc_cidr
  public_subet   = var.public_subet
  private_subnet = var.private_subnet
  environment    = var.environment
  nat_type       = "instance"
}
module "rds" {
  source                    = "./modules/rds"
  environment               = var.environment
  vpc_id                    = module.network.vpc_id
  cluster_identifier_prefix = "dummy"
  publicly_accessible       = false
  subnet_ids                = module.network.private_subnets_ids
  availability_zones        = slice(module.network.availability_zones, 0, 3)
  cluster_instances         = var.cluster_instances
  db_name                   = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
}
module "instances" {
  source                     = "./modules/instance"
  vpc_id                     = module.network.vpc_id
  private_subnets            = module.network.private_subnets_ids
  private-security-rules     = var.private-security-rules
  additional_security_groups = [module.rds.rds_access_sg_id]
  environment                = var.environment
  private_user_script        = base64encode(local.autossm)
  private_instances          = var.private_instances
  iam_role = module.roles.roles["ssmbygp"]
}
module "alb" {
  source             = "./modules/alb"
  environment        = var.environment
  public_subnets     = module.network.public_subnets_ids
  lb_name            = "task"
  instances          = module.instances.private_instances
  security_group_ids = [module.instances.private_security_groups]
  lb_sg_rules        = var.lb_sg_rules
  target_group_config = {
    port              = 80
    protocol          = "HTTP"
    vpc_id            = module.network.vpc_id
    target_type       = "instance"
    healthy_threshold = 2
  }
}

module "roles" {
  source = "./modules/iam"
  environment = var.environment
  roles =var.roles
}
output "out" {
  value = module.roles.roles
}