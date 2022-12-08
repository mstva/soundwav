#Google Compute Engine

variable "instance_name" { type = string }
variable "instance_machine_type" { type = string }
variable "instance_disk_image" { type = string }
variable "instance_disk_size" { type = string }
variable "instance_disk_type" { type = string }

resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.instance_machine_type

  boot_disk {
    initialize_params {
      image = var.instance_disk_image
      size  = var.instance_disk_size
      type  = var.instance_disk_type
    }
  }

  network_interface {
    network = "default"
  }

}
