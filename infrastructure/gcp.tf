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

module "gcp" {
  source = "./modules/gcp"

  storage_name     = "${local.project_name}-storage"
  storage_location = "US-EAST1"

}

output "gcp" {
  value     = module.gcp
  sensitive = true
}
