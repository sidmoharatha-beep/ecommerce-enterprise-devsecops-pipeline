# Enterprise E-commerce DevSecOps Pipeline

A 4-week enterprise-grade DevSecOps pipeline for e-commerce applications, built according to the Infotact Cybersecurity Project (Project 3).

## Prerequisites / Dependencies

Before working with this repository, make sure you have:

- **Git** — to clone the repository and work with branches
- **Docker** — to build and run the OWASP Juice Shop container locally
- **An AWS account** — only needed if you want to actually deploy the Terraform infrastructure; scanning and validation can run without it
- **Terraform CLI** — optional, but useful for local IaC validation with `terraform init` and `terraform validate`
- **A GitHub account** — required to fork, push changes, and configure repository secrets for GitHub Actions

## Project Overview

This repository implements a four-week DevSecOps pipeline around **OWASP Juice Shop**, demonstrating layered security controls across source code, dependencies, infrastructure, containers, and runtime behavior.

The pipeline is split across three contributor branches, each representing one week of work:

| Branch | Owner | Scope |
|--------|-------|-------|
| `sidhartha-branch` | Sidhartha | Week 1: Application Containerization + SAST |
| `chayan-branch` | Chayan | Week 2: Dependency SCA + Container Image Scanning |
| `aditya-branch` | Aditya | Week 3: IaC Scanning + Week 4: DAST + Pipeline Hardening |

The `main` branch carries the complete, unified 4-week implementation.

## Repository Deliverables

| Area | Files |
|------|-------|
| Target Application | `app/` — OWASP Juice Shop |
| Hardened Container | `Dockerfile` |
| Main CI/CD Workflow | `.github/workflows/devsecops-pipeline.yml` |
| IaC Workflow | `.github/workflows/iac-scan.yml` |
| SAST Configuration | `sonar-project.properties` |
| Terraform Deployment | `terraform/` |
| Documentation | `docs/week1.md`, `docs/week2.md`, `docs/week3.md`, `docs/week4.md` |

## Pipeline Flow

```text
Code Push / Pull Request
        |
        v
Secret Scan (TruffleHog)
        |
        v
Dependency Review (PR only)
        |
        v
SAST (SonarQube)
        |
        v
SCA (Trivy filesystem)
        |
        v
Docker Build
        |
        v
Container Image Scan (Trivy)
        |
        v
DAST (OWASP ZAP)

Separate workflow:
Terraform Init/Validate -> Checkov -> TFSec
```

## Week-by-Week Architecture

### Week 1 — Containerization and SAST

- OWASP Juice Shop added as the target application
- Hardened Docker image with non-root runtime and reduced attack surface
- SonarQube SAST integrated into GitHub Actions

See `docs/week1.md`.

### Week 2 — Dependency and Container Scanning

- **Trivy filesystem scan** added to inspect the repository for vulnerable dependencies
- **Trivy image scan** added to scan the built Docker image
- Pipeline fails on HIGH/CRITICAL findings

See `docs/week2.md`.

### Week 3 — IaC Scanning

Terraform under `terraform/` models a minimal secure AWS deployment:

- VPC with public and private subnets
- Application Load Balancer with HTTPS listener
- ACM certificate for TLS termination
- ECS Fargate service for the Juice Shop container
- CloudWatch logging
- Encrypted S3 bucket for ALB access logs with versioning and public access blocked
- Restrictive security groups between ALB and application tasks

The dedicated IaC workflow runs Terraform init, validate, Checkov scan, and TFSec scan.

See `docs/week3.md`.

### Week 4 — DAST and Pipeline Hardening

The main workflow now ends with a DAST stage:

- Builds the Juice Shop image
- Runs the container locally in GitHub Actions
- Executes an **OWASP ZAP baseline scan**
- Uploads the ZAP report as an artifact

Additional workflow hardening includes:

- Restricted `GITHUB_TOKEN` permissions
- Dependency review on pull requests
- TruffleHog secret scanning
- Pinned action versions where practical

See `docs/week4.md`.

## Required GitHub Secrets

Only two secrets are required to run the SonarQube SAST stage:

| Secret | Purpose |
|--------|---------|
| `SONAR_TOKEN` | Authentication token for SonarQube/SonarCloud |
| `SONAR_HOST_URL` | URL of your SonarQube server |

## How to Generate `SONAR_TOKEN` and `SONAR_HOST_URL`

### Option A — SonarCloud (easiest, free for public repos)

1. Go to **https://sonarcloud.io** and sign in with your GitHub account.
2. Click your profile picture (top-right) → **My Account**.
3. Go to the **Security** tab.
4. Under **Generate Tokens**, enter a name like `devsecops-pipeline` and click **Generate**.
5. Copy the token immediately — you will not see it again.
6. Your `SONAR_HOST_URL` is exactly: `https://sonarcloud.io`

### Option B — Self-Hosted SonarQube

1. Open your SonarQube web interface (for example `http://your-server:9000`).
2. Log in as an admin or the user that will run analysis.
3. Click your user avatar (top-right) → **My Account**.
4. Go to the **Security** tab.
5. Enter a token name like `github-actions` and click **Generate**.
6. Copy the token immediately.
7. Your `SONAR_HOST_URL` is the base URL of your SonarQube server, e.g. `http://your-server:9000` or `https://sonar.yourcompany.com`.

## How to Add Secrets to GitHub

1. Open the repository on GitHub: `https://github.com/sidmoharatha-beep/ecommerce-enterprise-devsecops-pipeline`
2. Click **Settings** (top tab).
3. In the left sidebar, expand **Secrets and variables** and select **Actions**.
4. Click **New repository secret**.
5. Add the first secret:
   - **Name:** `SONAR_TOKEN`
   - **Value:** the token you copied from SonarQube/SonarCloud
6. Click **Add secret**.
7. Repeat for the second secret:
   - **Name:** `SONAR_HOST_URL`
   - **Value:** `https://sonarcloud.io` for SonarCloud, or your self-hosted SonarQube URL

Once both secrets are added, the SonarQube SAST job will run automatically on the next push or pull request.

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

### Docker

```bash
docker build -t juice-shop .
docker run -p 3000:3000 juice-shop
```

### Terraform (optional local IaC validation)

```bash
cd terraform
terraform init -backend=false
terraform validate
```

## 4-Week Roadmap

- **Week 1:** OWASP Juice Shop containerization + SonarQube SAST ✅
- **Week 2:** SCA (Trivy) + Container image scanning ✅
- **Week 3:** IaC scanning with Checkov/TFSec ✅
- **Week 4:** DAST with OWASP ZAP + pipeline hardening ✅

## Technologies

- GitHub Actions
- OWASP Juice Shop
- SonarQube
- Trivy
- Checkov
- TFSec
- OWASP ZAP
- TruffleHog
- Terraform
- Docker
