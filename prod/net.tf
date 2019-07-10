resource "google_compute_network" "default" {
  name                    = "${var.env}-net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.env}-subnet"
  ip_cidr_range            = "10.30.10.0/24"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
}
