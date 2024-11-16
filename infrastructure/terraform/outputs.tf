output "iap_client_secret" {
  value = google_secret_manager_secret.iap_client_secret.id
}

output "iap_client_id" {
  value = google_iap_client.project_client.client_id
}

output "iap_client_secret_version" {
  value = google_secret_manager_secret_version.iap_client_secret_version.id
}

