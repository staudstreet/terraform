resource "tls_private_key" "acme-key" {
  algorithm = "RSA"
}

resource "acme_registration" "rbrk-reg" {
  account_key_pem = "${tls_private_key.acme-key.private_key_pem}"
  email_address   = "robinkomenda@gmail.com"
}

resource "acme_certificate" "rbrk-cert" {
  account_key_pem            = "${acme_registration.rbrk-reg.account_key_pem}"
  common_name                = "rbrk.at"
  subject_alternative_names = ["*.rbrk.at"]

  dns_challenge {
    provider = "ovh"

    config = {
      OVH_ENDPOINT                = "ovh-eu"  
      OVH_APPLICATION_KEY         = "${file("../secrets/ovh/application_key")}"
      OVH_APPLICATION_SECRET      = "${file("../secrets/ovh/application_secret")}"
      OVH_CONSUMER_KEY            = "${file("../secrets/ovh/consumer_key")}"
    }
  }
}
