output "vpc_id" {
  value = aws_vpc.tf-project-vpc.id
}

output "app-subnet" {
  value = aws_subnet.app-subnet
}

output "app-subnet-availability_zone_names" {
  value = random_shuffle.shuffle-az.result
}

output "web_subnet_ids" {
  value = data.aws_subnets.web_subnets.ids
}

output "db_subnet_ids" {
  value = aws_subnet.db-subnet.*.id
}
