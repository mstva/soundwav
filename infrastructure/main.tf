terraform {
  required_version = "1.3.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.1"
    }
  }
  backend "gcs" {}
}

locals { project_name = "soundwav" }
