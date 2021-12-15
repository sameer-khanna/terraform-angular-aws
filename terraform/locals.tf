locals {
  security_groups = {
    public = {
      name        = "webSG"
      description = "Security Group for Public Access"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  vpc_endpoints = {
    ssm = {
      service_name      = "com.amazonaws.us-east-1.ssm"
      vpc_endpoint_type = "Interface"
    }
    ssmmessages = {
      service_name      = "com.amazonaws.us-east-1.ssmmessages"
      vpc_endpoint_type = "Interface"
    }
  }
}
