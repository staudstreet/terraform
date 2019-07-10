module "homepage" {
  source       = "../modules/mig"

  name         = "homepage"
  env          = "${var.env}"
  zone         = "${var.zone}"
  min_replicas = "1"
  max_replicas = "3"
  init_script  = "${file("init.sh")}"
}

module "lb-https" {
  source       = "../modules/lb-https"

  name         = "lb-https"
  env          = "${var.env}"
  region       = "${var.region}"
  backend      = "${module.homepage.backend}"
#  priv-key     = "${acme_certificate.rbrk-cert.private_key_pem}"
#  cert         = "${acme_certificate.rbrk-cert.certificate_pem}"
}
