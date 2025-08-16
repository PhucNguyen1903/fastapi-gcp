# Artifact Registry Repository for Docker images
resource "google_artifact_registry_repository" "fastapi_app" {
  location      = var.artifact_registry_location
  repository_id = var.artifact_registry_repository_id
  description   = "Docker repository for FastAPI application"
  format        = "DOCKER"
  project       = var.project_id

  depends_on = [google_project_service.required_apis]
}

# IAM binding to allow the Artifact Registry service account to write to Artifact Registry
resource "google_artifact_registry_repository_iam_member" "writer" {
  location   = google_artifact_registry_repository.fastapi_app.location
  repository = google_artifact_registry_repository.fastapi_app.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.artifact_registry.email}"

  depends_on = [
    google_artifact_registry_repository.fastapi_app,
    google_service_account.artifact_registry
  ]
} 