resource "google_compute_global_forwarding_rule" "http" {
  name       = "${var.name}-forward"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  ip_address = "${google_compute_global_address.default.address}"
  port_range = "80"
}

#resource "google_compute_global_forwarding_rule" "https" {
#  name       = "${var.name}-https"
#  target     = "${google_compute_target_https_proxy.default.self_link}"
#  ip_address = "${google_compute_global_address.default.address}"
#  port_range = "443"
#}

resource "google_compute_global_address" "default" {
  name       = "${var.name}-address"
}

resource "google_compute_target_http_proxy" "default" {
  name     = "${var.name}-http-proxy"
  url_map  = "${google_compute_url_map.default.self_link}"
}

#resource "google_compute_target_https_proxy" "default" {
#  name        = "${var.name}-https-proxy"
#  url_map     = "${google_compute_url_map.default.self_link}"
#  ssl_certificates = ["${google_compute_ssl_certificate.default.self_link}"] 
#}

#resource "google_compute_ssl_certificate" "default" {
#  name        = "${var.name}-cert"
#  private_key = "${var.priv-key}"
#  certificate = "${var.cert}"
#}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-urlmap"
  default_service = "${var.backend}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${var.backend}"

    path_rule {
      paths   = ["/group1", "/group1/*"]
      service = "${var.backend}"
    }
  }
}

resource "google_compute_firewall" "default" {
  name          = "${var.name}-fw"
  network       = "${var.env}-net"
#  target_tags   = ["${var.target_tags}"]

  allow {
    protocol = "tcp"
    ports    = ["22" , "80" , "443"]
  }
}

resource "google_compute_router" "default" {
  name    = "${var.name}-router"
  region  = "${var.region}"
  network = "${var.env}-net"
}

resource "google_compute_router_nat" "default" {
  name                               = "${var.name}-router-nat"
  router                             = "${google_compute_router.default.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
