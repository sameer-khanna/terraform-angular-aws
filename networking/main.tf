
data "aws_availability_zones" "availaibility-zones" {
}

resource "random_shuffle" "shuffle-az" {
  input        = data.aws_availability_zones.availaibility-zones.names
  result_count = var.max_subnetcount
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "tf-project-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "tf-project-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "web-subnet" {
  count                   = var.web_subnet_count
  vpc_id                  = aws_vpc.tf-project-vpc.id
  cidr_block              = var.web_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.shuffle-az.result[count.index]
  tags = {
    Name = "web-${count.index + 1}"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.tf-project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "publicRT"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  count          = var.web_subnet_count
  subnet_id      = aws_subnet.web-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.tf-project-vpc.id
  tags = {
    Name = "privateRT"
  }
}

resource "aws_subnet" "app-subnet" {
  count             = var.app_subnet_count
  vpc_id            = aws_vpc.tf-project-vpc.id
  cidr_block        = var.app_cidr_blocks[count.index]
  availability_zone = random_shuffle.shuffle-az.result[count.index]
  tags = {
    Name = "app-${count.index + 1}"
  }
}

resource "aws_route_table_association" "app-rt-association" {
  count          = var.app_subnet_count
  subnet_id      = aws_subnet.app-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_subnet" "db-subnet" {
  count             = var.db_subnet_count
  vpc_id            = aws_vpc.tf-project-vpc.id
  cidr_block        = var.db_cidr_blocks[count.index]
  availability_zone = random_shuffle.shuffle-az.result[count.index]
  tags = {
    Name = "db-${count.index + 1}"
  }
}

resource "aws_route_table_association" "db-rt-association" {
  count          = var.db_subnet_count
  subnet_id      = aws_subnet.db-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_subnet" "reserved-subnet" {
  count             = var.reserved_subnet_count
  vpc_id            = aws_vpc.tf-project-vpc.id
  cidr_block        = var.reserved_cidr_blocks[count.index]
  availability_zone = random_shuffle.shuffle-az.result[count.index]
  tags = {
    Name = "reserved-${count.index + 1}"
  }
}

resource "aws_route_table_association" "reserved-rt-association" {
  count          = var.reserved_subnet_count
  subnet_id      = aws_subnet.reserved-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-project-vpc.id
  tags = {
    Name = "IGW"
  }
}