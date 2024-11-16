# https://cloud.google.com/iap/docs/authenticate-users-google-accounts#enabling_iap_sdk
# https://cloud.google.com/iap/docs/concepts-overview#gke
# https://cloud.google.com/iap/docs/enabling-kubernetes-howto
# These do not work on "non-internal" IAP endpoints, i.e. public facing. So cannot create a demo using these unless
# you have an organization

resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = "Cloud IAP protected Application"
  project           = var.project

  lifecycle {
      # Prevent destroy of the brand through terraform  because the delete api is not available
      prevent_destroy = true
  }
}

resource "google_iap_client" "project_client" {
  display_name = "Demo App"
  brand        =  google_iap_brand.project_brand.name
}
#
#
# setting up the IAP policy
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam
resource "google_iap_web_iam_binding" "binding" {
  project = var.project
  role = "roles/iap.httpsResourceAccessor"
  members = [
    "group:${var.user_group}",
  ]
  # IAP fine grained controls https://cloud.google.com/iam/docs/conditions-overview#request_attributes
  condition {
      title       = "Host-control-1"
      description = "Allows a specific hostname"
      expression  = "request.host == '${var.application_domain}'"
    }
}

resource "google_secret_manager_secret" "iap_client_secret" {
  secret_id = "iap-client-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "iap_client_secret_version" {
  secret      = google_secret_manager_secret.iap_client_secret.id
  # this is automatically base64 encoded. Can be directly used to create a k8 secret
  secret_data = google_iap_client.project_client.secret
}