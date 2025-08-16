## Project Overview

This is a POC FastAPI application that demonstrates a complete CI/CD pipeline using GitHub Actions, Docker containerization, and Google Cloud Platform (GCP) services. 

## CI/CD Pipeline

### Continuous Integration (CI)
The CI pipeline includes the following stages:

1. **Linting** - Code quality checks using flake8
2. **Unit Testing** - Automated test execution with pytest and coverage reporting
3. **Docker Build** - Multi-stage Docker image creation with distroless runtime
4. **Security Scanning** - Docker image vulnerability scanning
5. **Artifact Storage** - Push Docker image to GCP Artifact Registry

### Continuous Deployment (CD)
The CD pipeline includes:

1. **Deployment** - Deploy Docker image to GCP Cloud Run service
2. **Health Monitoring** - Automated health checks and monitoring

## GCP Integration

### Workload Indetity Federation with Github OIDC Provider

- WIF Pool with GH OIDC Provider, attribute mapping, attribute conditions

- For Service Account to be used with this authentication, it must have the permission Workload Identity User, in order for Federated workloads to impersonate

- Access to the pool were granted to the Service Accounts to impersonate

### Artifact Registry

- Service Account with proper permissions

### Cloudrun Service

- Service Account with proper permissions

  Must have roles/iam.serviceAccountUser for Cloudrun deployment

### Github Environment Settings

- Include the WIF Provider and Service Accounts to authenticate within the pipeline

## Terraform Infrastructure

This project uses Terraform to provision and manage the required GCP infrastructure:

### Infrastructure Components

- **Workload Identity Federation** - Secure authentication for GitHub Actions using OIDC
- **Artifact Registry** - Docker image repository for storing application containers
- **Service Accounts** - Dedicated service accounts for Artifact Registry and Cloud Run operations
- **IAM Permissions** - Proper role assignments for secure access control

### Key Resources

- Workload Identity Pool and Provider for GitHub Actions
- Artifact Registry repository for Docker images
- Service accounts with minimal required permissions
- IAM bindings for secure authentication
