#Google Compute Engine

variable "instance_name" { type = string }
variable "instance_machine_type" { type = string }
variable "instance_disk_image" { type = string }
variable "instance_disk_size" { type = string }
variable "instance_disk_type" { type = string }
variable "instance_user" { type = string }
variable "instance_ssh_key" { type = any }

resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.instance_machine_type
  tags         = ["allow-ssh", "allow-http"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.instance_disk_image
      size  = var.instance_disk_size
      type  = var.instance_disk_type
    }
  }

  network_interface {
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.main.id
    access_config {
      nat_ip = google_compute_address.main.address
    }
  }

  metadata = {
    ssh-keys = "${var.instance_user}:${var.instance_ssh_key}"
  }

}

output "INSTANCE_USER" {
  value = var.instance_user
}

output "INSTANCE_IP" {
  value = google_compute_instance.main.network_interface.0.access_config.0.nat_ip
}

output "INSTANCE_SSH_CONNECT" {
  value = "ssh ${var.instance_user}@${google_compute_instance.main.network_interface.0.access_config.0.nat_ip}"
}
