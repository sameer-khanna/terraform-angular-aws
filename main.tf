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
  vpc_endpoints         = local.vpc_endpoints
  security_group_ids = [
    module.compute.app_security_group_id
  ]
  availability_zone = module.loadbalancing.availability-zone
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
}

module "compute" {
  source                  = "./compute"
  instance_type           = "t2.micro"
  vpc_id                  = module.networking.vpc_id
  security_groups         = local.security_groups
  web_user_data           = filebase64("${path.module}/webserveruserdata.sh")
  app_user_data           = filebase64("${path.module}/appserveruserdata.sh")
  subnet_id               = module.networking.web-subnet[0].id
  sg_egress_cidr          = "0.0.0.0/0"
  sg_egress_from_port     = 0
  sg_egress_to_port       = 0
  sg_egress_Protocol      = "-1"
  app_sg_name             = "appSG"
  app_sg_description      = "Security group for the app servers"
  app_sg_from_port        = 0
  app_sg_to_port          = 0
  app_sg_protocol         = "-1"
  iam_managed_policy_s3   = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  iam_managed_policy_ssm  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ami_filter_name         = "amzn2-ami-hvm*"
  ami_filter_architecture = "x86_64"
  ami_owner               = "amazon"
  appserver_ami_id        = "ami-044c18f8b5288e490"
  iam_role_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

module "loadbalancing" {
  source                   = "./loadbalancing"
  web_asg_max_size         = 1
  web_asg_min_size         = 1
  web_asg_desired_capacity = 1
  availability_zones       = module.networking.web-subnet-availability_zone_names
  web_launch_template_id   = module.compute.web-launch_template_id
  web_security_group_ids   = module.compute.web_security-group-ids
  web_subnets              = module.networking.web-subnet.*.id
  web_port                 = 80
  web_protocol             = "HTTP"
  vpc_id                   = module.networking.vpc_id
  app_asg_max_size         = 1
  app_asg_min_size         = 1
  app_asg_desired_capacity = 1
  app_launch_template_id   = module.compute.app-launch_template_id
  app_security_group_ids   = module.compute.app_security-group-ids
  app_subnets              = module.networking.app_subnet_ids
  app_port                 = 8080
  app_listener_port        = 80
  app_protocol             = "HTTP"
}

module "dns" {
  source          = "./dns"
  alb_dns_zone_id = module.loadbalancing.alb-zone-id
  alb_dns_name    = module.loadbalancing.web-alb-dns
  hosted_zone     = "sameerkhanna.net."
}