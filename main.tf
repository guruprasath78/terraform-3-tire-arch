module "roles" {
  source = "./modules/iam"
  environment = var.environment
  roles =var.roles
}
module "network" {
  source         = "./modules/network"
  vpc_cidr       = var.vpc_cidr
  public_subet   = var.public_subet
  private_subnet = var.private_subnet
  environment    = var.environment
  nat_type       = "instance"
  nat_ssm_role = module.roles.roles["ssm"]
  nacl_private_rule = var.nacl_private_rule
  nacl_public_rule = var.nacl_public_rule
}
module "rds" {
  source                    = "./modules/rds"
  environment               = var.environment
  vpc_id                    = module.network.vpc_id
  cluster_identifier_prefix = "dummy"
  publicly_accessible       = false
  subnet_ids                = module.network.private_subnets_ids
  availability_zones        = slice(module.network.availability_zones, 0,2)
  cluster_instances         = var.cluster_instances
  db_name                   = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
}
module "instances" {
  source                     = "./modules/instance"
  vpc_id                     = module.network.vpc_id
  subnets            = module.network.private_subnets_ids
  security-rules     = var.private-security-rules
  security_groups_to_attach = [module.rds.rds_access_sg_id]
  environment                = var.environment
  user_data       = base64encode(local.private_userdata)
  instances          = var.private_instances
  iam_role = module.roles.roles["ssm"]
}
module "alb" {
  source             = "./modules/alb"
  environment        = var.environment
  public_subnets     = module.network.public_subnets_ids
  instance_ids          = module.instances.instance_ids
  security_group_ids = [module.instances.security_group_id]
  lb_sg_rules        = var.lb_sg_rules
  target_group_config = {
    port              = 80
    protocol          = "HTTP"
    vpc_id            = module.network.vpc_id
    target_type       = "instance"
    healthy_threshold = 2
  }
}
