output "website-url" {
  value = "http://${module.dns.fqdn}"
}