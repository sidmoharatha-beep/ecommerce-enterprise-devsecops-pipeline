# Enterprise E-commerce DevSecOps Pipeline

This repository implements a four-week DevSecOps pipeline around **OWASP Juice Shop**, demonstrating layered security controls across source code, dependencies, infrastructure, containers, and runtime behavior.

## Project Scope

The project uses an intentionally vulnerable e-commerce application to show how security tooling can be integrated into CI/CD in progressive stages:

- **Week 1:** Container hardening and SAST
- **Week 2:** Software composition and container scanning
- **Week 3:** Infrastructure as Code validation and scanning
- **Week 4:** DAST and workflow hardening

## Repository Deliverables

| Area | Files |
|------|-------|
| Application | `app/` |
| Hardened container build | `Dockerfile` |
| Main CI/CD workflow | `.github/workflows/devsecops-pipeline.yml` |
| IaC workflow | `.github/workflows/iac-scan.yml` |
| SonarQube config | `sonar-project.properties` |
| Terraform deployment | `terraform/` |
| Documentation | `docs/week1.md`, `docs/week3.md`, `docs/week4.md` |

## Week-by-Week Architecture

### Week 1 - Containerization and SAST

- OWASP Juice Shop added as the target application
- Hardened Docker image with non-root runtime and reduced attack surface
- SonarQube SAST integrated into GitHub Actions

See `docs/week1.md`.

### Week 2 - Dependency and Container Scanning

- Dependency and image scanning stage added to the pipeline roadmap
- Supports layered analysis beyond source code

### Week 3 - IaC Scanning

Terraform under `terraform/` models a minimal secure AWS deployment:

- VPC with public and private subnets
- Application Load Balancer with HTTPS listener
- ACM certificate for TLS termination
- ECS Fargate service for the Juice Shop container
- CloudWatch logging
- Encrypted S3 bucket for ALB access logs with versioning and public access blocked
- Restrictive security groups between ALB and application tasks

The dedicated IaC workflow:

1. installs Terraform
2. runs `terraform init -backend=false`
3. runs `terraform validate`
4. scans Terraform with **Checkov**
5. scans Terraform with **TFSec**
6. uploads SARIF and artifact outputs

See `docs/week3.md`.

### Week 4 - DAST and Pipeline Hardening

The main workflow now ends with a **DAST** stage:

- builds the Juice Shop image
- runs the container locally in GitHub Actions
- executes an **OWASP ZAP baseline scan**
- uploads the ZAP report as an artifact

Additional workflow hardening includes:

- restricted `GITHUB_TOKEN` permissions
- dependency review on pull requests
- TruffleHog secret scanning
- pinned action versions where practical

See `docs/week4.md`.

## Pipeline Flow

```text
Secret Scan -> SAST -> Docker Build -> DAST
                ^
                |
         Dependency Review (PR only)

Separate workflow:
Terraform Init/Validate -> Checkov -> TFSec
```

## Required GitHub Secrets

- `SONAR_TOKEN`
- `SONAR_HOST_URL`

## Local Validation Examples

### Docker

```bash
docker build -t juice-shop .
docker run -p 3000:3000 juice-shop
```

### Terraform

```bash
cd terraform
terraform init -backend=false
terraform validate
```

## Security Tooling Used

- GitHub Actions
- SonarQube
- Checkov
- TFSec
- OWASP ZAP
- TruffleHog
- Docker
- Terraform
- OWASP Juice Shop
