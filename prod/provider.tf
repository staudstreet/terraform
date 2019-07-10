terraform {
  backend "gcs" {
    credentials    = "~/Projects/rbrk.at/terraform/secrets/rbrk-prod.json"  
    bucket         = "rbrk-prod-tfstate"
  }
}

provider "google" {
  region	= "${var.region}"
  credentials 	= "${file("../secrets/rbrk-dev.json")}"
  project     	= "${var.project}"
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = "${file("../secrets/ovh/application_key")}"
  application_secret = "${file("../secrets/ovh/application_secret")}"
  consumer_key       = "${file("../secrets/ovh/consumer_key")}"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
