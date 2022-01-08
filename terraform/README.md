# The Terraform code has the following modules - 
* **Networking** - For VPC and all the related networking. We are using the 10.16.0.0/16 CIDR for the VPC and 16 /20 subnets (4 each for web, app, db and reserved). The subnets are spread across 4 AZs for high availability. This also creates a Gateway endpoint for S3 and multiple Interface endpoints in the App subnets for Sessions Manager.
* **Compute** - For the launch templates, EC2 instances, instance profiles and security groups. The compute module first builds launch templates complete with user data and other settings and uses that to launch web and app instances in their respective ASGs. The Angular and Spring boot code resides in an S3 bucket that is pulled by the EC2 instances during bootstrapping.
* **Load Balancing** -  For setting up the ASGs, ALBs, target groups, target group attachments and listeners for both web and app tiers. 
* **DNS** - This is for creating an alias record to the web ALB (internet facing) in an existing public hosted zone. It also creates a private hosted zone (accessible only from the VPC) and an alias record in it that points at the app (internal) ALB.
* **Database** - This is for creating a subnet group and an RDS instance.
* **Parameters** - This is for creating RDS related parameters in the Systems Manager Parameter Store. 
* **Root** - This is the root module for orchestration between the other modules. The dynamic values are passed in from here to the modules. This makes the modules re-usable. 
