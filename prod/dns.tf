resource "ovh_domain_zone_record" "homepage" {
  zone = "rbrk.at"
  subdomain = ""
  fieldtype = "A"
  ttl       = "3600"
  #target    = "${google_compute_instance.homepage.network_interface.0.access_config.0.nat_ip}"
  target    = "${module.lb-https.ip}"
}
