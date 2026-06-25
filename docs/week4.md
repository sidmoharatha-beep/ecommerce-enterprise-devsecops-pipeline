# Week 4 - DAST and Pipeline Hardening

## Objective

Week 4 completes the DevSecOps pipeline by adding Dynamic Application Security Testing and strengthening CI workflow security controls.

## DAST Implementation

The main pipeline now includes a final `dast` job that:

1. Builds the hardened Juice Shop container
2. Runs the container locally on the GitHub Actions runner
3. Waits for the application to become reachable
4. Executes an **OWASP ZAP baseline scan** against `http://127.0.0.1:3000`
5. Uploads the generated ZAP HTML report as a workflow artifact

This approach keeps DAST self-contained and reproducible without requiring an external environment.

## DAST Findings Summary

OWASP Juice Shop is intentionally vulnerable, so ZAP is expected to report findings such as:

- missing or weak security headers
- cookie-related issues
- information disclosure indicators
- outdated client-side patterns
- input handling weaknesses exposed through passive checks

Because Juice Shop is a training target, these findings are useful as evidence that the DAST stage is functioning correctly. In a production application, the same findings would be triaged and remediated before release.

## Pipeline Hardening Decisions

The workflow was hardened with the following controls:

- **Restricted `GITHUB_TOKEN` permissions** at workflow level
- **Dependency review** on pull requests using `actions/dependency-review-action`
- **Secret scanning** using `trufflesecurity/trufflehog`
- **Pinned major action versions** instead of floating tags where practical
- **Artifact retention** for security scan outputs

## Why These Controls Matter

### Dependency Review

Prevents risky dependency changes from being merged without visibility into:

- vulnerable packages
- license concerns
- unexpected transitive risk

### Secret Scanning

Detects accidentally committed credentials, tokens, and keys before they spread through the repository history or CI logs.

### Least-Privilege Workflow Permissions

Reduces blast radius if a workflow step or third-party action is compromised.

### DAST as Final Gate

Adds runtime validation after build-time checks, helping catch issues that SAST, SCA, and IaC scanners cannot observe.

## Final 4-Week Conclusion

The project now demonstrates a layered DevSecOps pipeline:

1. **Week 1:** Container hardening and SAST
2. **Week 2:** Dependency and container scanning
3. **Week 3:** Terraform validation and IaC scanning
4. **Week 4:** Runtime DAST and workflow hardening

Together, these stages provide defense in depth across source code, dependencies, infrastructure definitions, container artifacts, and runtime behavior.