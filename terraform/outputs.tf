output "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  value       = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
}

output "workload_identity_provider_id" {
  description = "Workload Identity Provider ID"
  value       = google_iam_workload_identity_pool_provider.github_actions.workload_identity_pool_provider_id
}

output "artifact_registry_service_account_email" {
  description = "Artifact Registry Service Account email for pushing images"
  value       = google_service_account.artifact_registry.email
}

output "artifact_registry_service_account_name" {
  description = "Artifact Registry Service Account name"
  value       = google_service_account.artifact_registry.name
}

output "cloud_run_service_account_email" {
  description = "Cloud Run Service Account email for deploying services"
  value       = google_service_account.cloud_run.email
}

output "cloud_run_service_account_name" {
  description = "Cloud Run Service Account name"
  value       = google_service_account.cloud_run.name
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository name"
  value       = google_artifact_registry_repository.fastapi_app.name
}

output "artifact_registry_location" {
  description = "Artifact Registry repository location"
  value       = google_artifact_registry_repository.fastapi_app.location
}

output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP Region"
  value       = var.region
}

output "workload_identity_provider_resource_name" {
  description = "Full resource name of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github_actions.name
} 