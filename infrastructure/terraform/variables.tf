variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable credentials_file {
  description = "The path to the GCP service account key file"
  type        = string
}

variable "support_email" {
  description = "The email address of the support team"
  type        = string
}

variable "user_group" {
  description = "The email address of the user group or individual user"
  type        = string
}

variable "application_domain" {
  description = "The domain name of the application to be protected by IAP"
  type        = string
}