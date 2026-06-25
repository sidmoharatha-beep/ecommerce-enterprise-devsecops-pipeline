# Week 1: Application Containerization and SAST

## Overview
This week establishes the baseline e-commerce application and pipeline foundation. We selected OWASP Juice Shop as the intentionally vulnerable target application because it provides realistic e-commerce functionality and a broad attack surface for downstream security scanners.

## Key Decisions

### Target Application
- **OWASP Juice Shop** cloned into `app/`
- A modern full-stack JavaScript e-commerce application
- Provides realistic vulnerabilities for SAST, SCA, container, IaC, and DAST scanners

### Containerization
- `Dockerfile` uses a multi-stage build
- Builder stage installs dependencies and compiles application
- Runtime stage copies only production artifacts
- Container runs as a dedicated non-root user

### SAST Integration
- SonarQube scanner invoked via `SonarSource/sonarqube-scan-action`
- Quality gate check via `SonarSource/sonarqube-quality-gate-action`
- Pipeline fails when critical OWASP Top 10 vulnerabilities or quality gate violations are detected

## Files Added

| File | Purpose |
|------|---------|
| `app/` | OWASP Juice Shop source code |
| `Dockerfile` | Hardened container image definition |
| `.dockerignore` | Excludes unnecessary files from build context |
| `.github/workflows/devsecops-pipeline.yml` | CI/CD pipeline |
| `sonar-project.properties` | SonarQube project configuration |
| `README.md` | Project overview |

## Validation

1. Build the image locally:
   ```bash
   docker build -t juice-shop .
   ```
2. Run the container:
   ```bash
   docker run -p 3000:3000 juice-shop
   ```
3. Open `http://localhost:3000` to access the application.

## Compliance with PDF Requirements

| PDF Requirement | Implementation |
|-----------------|---------------|
| Containerize target application | `Dockerfile` + `app/` |
| Non-root user setup | `USER appuser` in Dockerfile |
| CI/CD orchestration | `.github/workflows/devsecops-pipeline.yml` |
| SAST with SonarQube | `sonar-project.properties` + workflow step |
| Fail on critical findings | SonarQube quality gate action |
