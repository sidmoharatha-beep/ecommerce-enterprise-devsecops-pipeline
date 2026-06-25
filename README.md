# Enterprise E-commerce DevSecOps Pipeline

A 4-week enterprise-grade DevSecOps pipeline for e-commerce applications, built according to the Infotact Cybersecurity Project (Project 3).

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

### Required GitHub Secrets

- `SONAR_TOKEN` — SonarQube authentication token
- `SONAR_HOST_URL` — SonarQube server URL

### Local Testing

```bash
docker build -t juice-shop .
docker run -p 3000:3000 juice-shop
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
