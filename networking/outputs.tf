output "vpc_id" {
  value = aws_vpc.tf-project-vpc.id
}

output "web-subnet" {
  value = aws_subnet.web-subnet
}