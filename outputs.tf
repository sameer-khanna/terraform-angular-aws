# output "alb-dns-name" {
#   value = module.loadbalancing.alb-dns
# }

output "website-url" {
  value = "http://${module.dns.fqdn}"
}