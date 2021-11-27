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