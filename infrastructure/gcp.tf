variable "gcp" {
  type    = map(string)
  default = {
    project     = ""
    region      = ""
    zone        = ""
    credentials = ""
  }
}

provider "google" {
  project     = var.gcp.project
  region      = var.gcp.region
  zone        = var.gcp.zone
  credentials = var.gcp.credentials
}

variable "database_password" { type = string }

module "gcp" {
  source = "./modules/gcp"

  storage_name     = "${local.project_name}-storage"
  storage_location = "US-EAST1"

  database_instance_name = "${local.project_name}-database"
  database_version       = "POSTGRES_14"
  database_tier          = "db-f1-micro"
  database_name          = "${local.project_name}_db"
  database_username      = "${local.project_name}_user"
  database_password      = var.database_password

  instance_name         = "${local.project_name}-instance"
  instance_machine_type = "e2-micro"
  instance_disk_image   = "ubuntu-os-cloud/ubuntu-2004-lts"
  instance_disk_size    = "10"
  instance_disk_type    = "pd-ssd"
  instance_user         = "${local.project_name}_user"
  instance_ssh_key      = file("${path.module}/.ssh/id_rsa.pub")

  network_name            = "${local.project_name}-network"
  network_address_name    = "${local.project_name}-network-address"
  network_subnetwork_name = "${local.project_name}-network-subnetwork"
}

output "gcp" {
  value     = module.gcp
  sensitive = true
}
