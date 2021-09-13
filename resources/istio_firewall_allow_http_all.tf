resource "google_compute_firewall" "istio_http" {
  name =   format("allow-http-all-istio-in-privategke-%s-%s-%s", var.org, var.product, var.environment)
  network = google_compute_network.vpc_network.self_link
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["80","8080"]
  }
}