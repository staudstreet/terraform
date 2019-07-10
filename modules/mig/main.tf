resource "google_compute_instance_template" "default" {
  name_prefix    = "${var.name}-template-"


  machine_type   = "f1-micro"
  can_ip_forward = false

  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = "${var.env}-subnet"
  }

  metadata_startup_script = "${var.init_script}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "${var.name}-mig"
  base_instance_name = "${var.name}-instance"
  instance_template  = "${google_compute_instance_template.default.self_link}"
  zone               = "${var.zone}"
  target_size        = "${var.min_replicas}"

  named_port {
    name = "ssh"
    port = 22
  }
  
  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }
}

resource "google_compute_health_check" "default" {
  name                = "${var.name}-healthcheck"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10                         # 50 seconds

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_autoscaler" "default" {
  name   = "${var.name}-autoscale"
  zone   = "${var.zone}"
  target = "${google_compute_instance_group_manager.default.self_link}"

  autoscaling_policy {
    max_replicas    = "${var.max_replicas}"
    min_replicas    = "${var.min_replicas}"
    cooldown_period = 60    

    cpu_utilization  {
      target = 0.7
    }
  }
}

resource "google_compute_backend_service" "default" {
  name      = "${var.name}-backend"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = "${google_compute_instance_group_manager.default.instance_group}"
  }

  health_checks = [
    "${google_compute_health_check.default.self_link}"
  ]
}
