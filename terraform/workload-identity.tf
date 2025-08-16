# Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions"
  project                   = var.project_id

  depends_on = [google_project_service.required_apis]
}

# Workload Identity Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  project                            = var.project_id

  display_name = "GitHub Actions Provider"
  description  = "OIDC provider for GitHub Actions"

  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "attribute.repository_owner == \"${var.github_repository_owner}\""
}

# Service Account for Artifact Registry (pushing images)
resource "google_service_account" "artifact_registry" {
  account_id   = var.artifact_registry_sa_name
  display_name = var.artifact_registry_sa_display_name
  description  = var.artifact_registry_sa_description
  project      = var.project_id

  depends_on = [google_project_service.required_apis]
}

# Service Account for Cloud Run (deploying services)
resource "google_service_account" "cloud_run" {
  account_id   = var.cloud_run_sa_name
  display_name = var.cloud_run_sa_display_name
  description  = var.cloud_run_sa_description
  project      = var.project_id

  depends_on = [google_project_service.required_apis]
}

# IAM binding to allow the Workload Identity Provider to impersonate the Artifact Registry Service Account
resource "google_service_account_iam_binding" "artifact_registry_workload_identity_user" {
  service_account_id = google_service_account.artifact_registry.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository_owner/${var.github_repository_owner}"
  ]

  depends_on = [
    google_iam_workload_identity_pool_provider.github_actions,
    google_service_account.artifact_registry
  ]
}

# IAM binding to allow the Workload Identity Provider to impersonate the Cloud Run Service Account
resource "google_service_account_iam_binding" "cloud_run_workload_identity_user" {
  service_account_id = google_service_account.cloud_run.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository_owner/${var.github_repository_owner}"
  ]

  depends_on = [
    google_iam_workload_identity_pool_provider.github_actions,
    google_service_account.cloud_run
  ]
}

# Define IAM permissions for each service account
locals {
  service_account_permissions = {
    "artifact-registry-writer" = {
      service_account = google_service_account.artifact_registry.email
      role            = "roles/artifactregistry.writer"
    }
    "cloud-run-admin" = {
      service_account = google_service_account.cloud_run.email
      role            = "roles/run.admin"
    }
    "cloud-run-service-account-user" = {
      service_account = google_service_account.cloud_run.email
      role            = "roles/iam.serviceAccountUser"
    }
    "cloud-run-artifact-registry-reader" = {
      service_account = google_service_account.cloud_run.email
      role            = "roles/artifactregistry.reader"
    }
  }
}

# Grant IAM permissions to service accounts using a single loop
resource "google_project_iam_member" "service_account_permissions" {
  for_each = local.service_account_permissions

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.service_account}"

  depends_on = [
    google_service_account.artifact_registry,
    google_service_account.cloud_run
  ]
}
