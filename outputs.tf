output "api-url" {
  value = "http://${module.loadbalancing.web-alb-dns}/api/helloworld"
}

output "website-url" {
  value = "http://${module.dns.fqdn}"
}