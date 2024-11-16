provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
}

terraform {
  backend "gcs" {
    bucket  = "project-state-17701"
    prefix  = "terraform/state"
  }
}