# Week 2: Software Composition Analysis and Container Scanning

## Overview
This week extends the DevSecOps pipeline with dependency and container vulnerability scanning. Trivy was selected because it supports both filesystem-based Software Composition Analysis and container image scanning in GitHub Actions with straightforward failure gating.

## Key Decisions

### SCA Tooling
- **Trivy filesystem scan** added to inspect the repository for vulnerable dependencies
- Scan configured to fail on **HIGH** and **CRITICAL** findings
- `ignore-unfixed: true` used to reduce noise from vulnerabilities without available remediations

### Container Security
- Docker image is built after SAST and SCA pass
- **Trivy image scan** runs against the built `juice-shop:${{ github.sha }}` image
- Pipeline fails when high or critical image vulnerabilities are detected

### Pipeline Flow
- `sast` remains the first security gate
- `sca` runs after SAST to validate dependencies before image creation
- `build-and-scan` runs last so only code that passes earlier gates is containerized

## Files Updated

| File | Purpose |
|------|---------|
| `.github/workflows/devsecops-pipeline.yml` | Added Trivy SCA and image scanning jobs |
| `README.md` | Updated project overview and Week 2 status |
| `docs/week2.md` | Week 2 implementation notes |

## Validation

1. Review the workflow syntax:
   ```bash
   git diff -- .github/workflows/devsecops-pipeline.yml
   ```
2. Push the branch to GitHub and confirm the workflow runs:
   - `SonarQube SAST`
   - `Dependency SCA`
   - `Build and Scan Docker Image`
3. Verify the pipeline fails when Trivy reports **HIGH** or **CRITICAL** vulnerabilities.

## Compliance with PDF Requirements

| PDF Requirement | Implementation |
|-----------------|---------------|
| SCA integration | Trivy filesystem scan in GitHub Actions |
| Container image scanning | Trivy image scan after Docker build |
| CI/CD failure gate | `exit-code: 1` on HIGH/CRITICAL findings |
| Documentation | `docs/week2.md` + updated `README.md` |