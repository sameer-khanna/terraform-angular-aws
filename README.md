# terraform-angular-aws
#### Terraform code that creates a VPC with all the networking and an EC2 instance with NGINX installed on it that runs a sample Angular app.

The code has the following modules - 
* **Networking** - For VPC and all the related networking. We are using the 10.16.0.0/16 CIDR for the VPC and 16 /20 subnets (4 each for web, app, db and reserved). The subnets are spread across 4 AZs for high availability.  
* **Compute** - For the launch template, EC2 instance, instance profile and security groups. The compute module first builds a launch template complete with user data and other settings and uses that to launch an instance. The sample Angular code resides in an S3 bucket that is pulled by the EC2 during bootstrapping. 
* **Load Balancing** -  For setting up the ASG, ALB, target group, target group attachments and listener. 
* **Root** - This is the root module for orchestration between the other modules. The dynamic values are passed in from here to the modules. This makes the modules re-usable. 
