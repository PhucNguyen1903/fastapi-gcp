variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-southeast1"
}

variable "github_repository_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "owner"
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-actions-pool"
}

variable "workload_identity_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "github-actions-provider"
}

# Service Account for Artifact Registry (pushing images)
variable "artifact_registry_sa_name" {
  description = "Name of the service account for Artifact Registry operations"
  type        = string
  default     = "artifact-registry-sa"
}

variable "artifact_registry_sa_display_name" {
  description = "Display name for the Artifact Registry service account"
  type        = string
  default     = "Artifact Registry Service Account"
}

variable "artifact_registry_sa_description" {
  description = "Description for the Artifact Registry service account"
  type        = string
  default     = "Service account for pushing Docker images to Artifact Registry"
}

# Service Account for Cloud Run (deploying services)
variable "cloud_run_sa_name" {
  description = "Name of the service account for Cloud Run operations"
  type        = string
  default     = "cloud-run-sa"
}

variable "cloud_run_sa_display_name" {
  description = "Display name for the Cloud Run service account"
  type        = string
  default     = "Cloud Run Service Account"
}

variable "cloud_run_sa_description" {
  description = "Description for the Cloud Run service account"
  type        = string
  default     = "Service account for deploying Cloud Run services"
}

variable "artifact_registry_location" {
  description = "Location for Artifact Registry repository"
  type        = string
  default     = "asia-southeast1"
}

variable "artifact_registry_repository_id" {
  description = "Artifact Registry repository ID"
  type        = string
  default     = "fastapi-app"
}

variable "cloud_run_service_name" {
  description = "Name for the Cloud Run service"
  type        = string
  default     = "fastapi-app"
}

variable "cloud_run_location" {
  description = "Location for Cloud Run service"
  type        = string
  default     = "asia-southeast1"
} 