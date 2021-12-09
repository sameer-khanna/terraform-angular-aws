variable "web_asg_max_size" {}
variable "web_asg_min_size" {}
variable "web_asg_desired_capacity" {}
variable "availability_zones" {}
variable "web_launch_template_id" {}
variable "web_security_group_ids" {}
variable "web_subnets" {}
variable "web_port" {}
variable "web_protocol" {}
variable "vpc_id" {}
variable "app_launch_template_id" {}


variable "app_asg_max_size" {}
variable "app_asg_min_size" {}
variable "app_asg_desired_capacity" {}
variable "app_security_group_ids" {}
variable "app_subnets" {}
variable "app_port" {}
variable "app_protocol" {}