output "web_server_public_ips" {
  description = "Public IP addresses of web servers"
  value       = yandex_compute_instance.web[*].network_interface[0].nat_ip_address
}

output "web_server_private_ips" {
  description = "Private IP addresses of web servers"
  value       = yandex_compute_instance.web[*].network_interface[0].ip_address
}

output "load_balancer_ip" {
  description = "Public IP address of the load balancer"
  value       = yandex_alb_load_balancer.web_lb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "database_host" {
  description = "PostgreSQL cluster host FQDN"
  value       = yandex_mdb_postgresql_cluster.app_db.host[0].fqdn
}

output "app_url" {
  description = "Application URL"
  value       = "https://${var.domain_name}"
}

output "dns_nameservers" {
  description = "NS servers for domain delegation"
  value       = yandex_dns_zone.app_zone.name_servers
}
