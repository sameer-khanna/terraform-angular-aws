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
  source                  = "./compute"
  instance_type           = "t2.micro"
  vpc_id                  = module.networking.vpc_id
  security_groups         = local.security_groups
  user_data               = filebase64("${path.module}/userdata.sh")
  subnet_id               = module.networking.web-subnet[0].id
  sg_egress_cidr          = "0.0.0.0/0"
  sg_egress_from_port     = 0
  sg_egress_to_port       = 0
  sg_egress_Protocol      = "-1"
  iam_managed_policy_s3   = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  iam_managed_policy_ssm  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ami_filter_name         = "amzn2-ami-hvm*"
  ami_filter_architecture = "x86_64"
  ami_owner               = "amazon"
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
}

module "dns" {
  source          = "./dns"
  alb_dns_zone_id = module.loadbalancing.alb-zone-id
  alb_dns_name    = module.loadbalancing.alb-dns
  hosted_zone     = "sameerkhanna.net."
}