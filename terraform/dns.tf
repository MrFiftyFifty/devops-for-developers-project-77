resource "yandex_dns_zone" "app_zone" {
  name        = "app-dns-zone"
  description = "Public DNS zone for the application"
  zone        = "${var.domain_name}."
  public      = true
}

resource "yandex_dns_recordset" "app_a_record" {
  zone_id = yandex_dns_zone.app_zone.id
  name    = "${var.domain_name}."
  type    = "A"
  ttl     = 300
  data    = [yandex_alb_load_balancer.web_lb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "app_www_cname" {
  zone_id = yandex_dns_zone.app_zone.id
  name    = "www.${var.domain_name}."
  type    = "CNAME"
  ttl     = 300
  data    = ["${var.domain_name}."]
}

resource "yandex_dns_recordset" "certificate_validation" {
  zone_id = yandex_dns_zone.app_zone.id
  name    = yandex_cm_certificate.web_certificate.challenges[0].dns_name
  type    = yandex_cm_certificate.web_certificate.challenges[0].dns_type
  ttl     = 300
  data    = [yandex_cm_certificate.web_certificate.challenges[0].dns_value]
}
