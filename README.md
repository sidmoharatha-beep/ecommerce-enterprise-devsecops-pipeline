# Enterprise E-commerce DevSecOps Pipeline

A 4-week enterprise-grade DevSecOps pipeline for e-commerce applications, built according to the Infotact Cybersecurity Project (Project 3).

## Prerequisites / Dependencies

Before working with this repository, make sure you have:

- **Git** — to clone the repository and work with branches
- **Docker** — to build and run the OWASP Juice Shop container locally
- **An AWS account** — only needed if you want to actually deploy the Terraform infrastructure; scanning and validation can run without it
- **Terraform CLI** — optional, but useful for local IaC validation with `terraform init` and `terraform validate`
- **A GitHub account** — required to fork, push changes, and configure repository secrets for GitHub Actions

## Week 1: Application Containerization & SAST

### Objective
Containerize an intentionally vulnerable e-commerce application (OWASP Juice Shop) with security hardening, and integrate Static Application Security Testing (SAST) using SonarQube as a CI/CD failure gate.

### Deliverables

| Deliverable | File |
|-------------|------|
| Target Application | `app/` — OWASP Juice Shop |
| Hardened Container | `Dockerfile` |
| CI/CD Pipeline | `.github/workflows/devsecops-pipeline.yml` |
| SAST Configuration | `sonar-project.properties` |
| Documentation | `docs/week1.md` |

### Hardening Controls Applied

- **Non-root user** execution (`appuser:appgroup`)
- **Multi-stage Docker build** to exclude build tools from runtime image
- **Minimal Alpine Linux** base image
- **Dependency pinning** via `package-lock.json`
- **Disabled post-install scripts** to reduce supply-chain attack surface
- **Container health check** for runtime liveness

### GitHub Actions Workflow

The Week 1 workflow runs on push/PR to `main` and `develop`:

1. **SAST with SonarQube** — scans source code; fails if quality gate is missed.
2. **Docker Build** — builds the hardened image.

## Required GitHub Secrets

- `SONAR_TOKEN` — SonarQube authentication token (from SonarCloud or self-hosted SonarQube)
- `SONAR_HOST_URL` — your SonarQube server URL (use `https://sonarcloud.io` for SonarCloud, or your self-hosted URL)

## Tools That Do NOT Need Secrets

The following tools run inside GitHub Actions without extra API keys:

- Checkov
- TFSec
- OWASP ZAP
- TruffleHog
- GitHub `dependency-review-action`
- `terraform validate`

## How to Add Secrets

In GitHub, open your repository and go to:

**Settings -> Secrets and variables -> Actions -> New repository secret**

Add `SONAR_TOKEN` and `SONAR_HOST_URL` there before running the SonarQube stage in GitHub Actions.

## Local Setup

```bash
docker build -t juice-shop .
docker run -p 3000:3000 juice-shop
```

```bash
cd terraform
terraform init -backend=false
terraform validate
```

## 4-Week Roadmap

- **Week 1:** OWASP Juice Shop containerization + SonarQube SAST ✅
- **Week 2:** SCA (Trivy/Snyk) + Container image scanning
- **Week 3:** IaC scanning with Checkov/TFSec
- **Week 4:** DAST with OWASP ZAP + pipeline hardening

## Technologies

- GitHub Actions
- OWASP Juice Shop
- SonarQube
- Trivy
- Checkov
- OWASP ZAP
- Docker
