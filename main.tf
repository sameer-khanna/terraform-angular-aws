module "networking" {
  source                = "./networking"
  vpc_cidr              = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true
  web_subnet_count      = 4
  app_subnet_count      = 4
  db_subnet_count       = 4
  reserved_subnet_count = 4
  web_cidr_blocks       = [for i in range(0, 4, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  app_cidr_blocks       = [for i in range(4, 8, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  db_cidr_blocks        = [for i in range(8, 12, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  reserved_cidr_blocks  = [for i in range(12, 16, 1) : cidrsubnet(var.vpc_cidr, 4, i)]
  max_subnetcount       = 20
}

module "compute" {
  source          = "./compute"
  instance_type   = "t2.micro"
  vpc_id          = module.networking.vpc_id
  security_groups = local.security_groups
  user_data       = filebase64("${path.module}/userdata.sh")
  subnet_id       = module.networking.web-subnet[0].id
}

module "loadbalancing" {
  source               = "./loadbalancing"
  asg_max_size         = 2
  asg_min_size         = 1
  asg_desired_capacity = 2
  availability_zones   = module.networking.web-subnet-availability_zone_names
  launch_template_id   = module.compute.launch_template_id
  security_group_ids   = module.compute.security-group-ids
  subnets              = module.networking.web-subnet.*.id
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = module.networking.vpc_id
  target_id            = module.compute.aws_instance_id
}