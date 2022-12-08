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
