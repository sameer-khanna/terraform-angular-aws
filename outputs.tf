output "api-url" {
  value = "http://${module.dns.app-fqdn}/api/helloworld"
}

output "website-url" {
  value = "http://${module.dns.web-fqdn}"
}