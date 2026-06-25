# Week 3 - Infrastructure as Code Scanning

## Objective

Week 3 extends the DevSecOps pipeline with Infrastructure as Code validation and security scanning for a minimal AWS deployment of OWASP Juice Shop.

## Terraform Architecture

The Terraform configuration in `terraform/` models a small but realistic AWS deployment:

- **VPC** with DNS support enabled
- **Two public subnets** for the Application Load Balancer
- **Two private subnets** for ECS Fargate tasks
- **Application Load Balancer** with HTTPS-only listener
- **ACM certificate** for TLS termination
- **ECS Fargate service** running the Juice Shop container
- **CloudWatch log group** for application logs
- **S3 bucket** for ALB access logs with:
  - versioning enabled
  - server-side encryption enabled
  - public access blocked
  - TLS-only bucket policy
- **Security groups** that restrict ingress to HTTPS on the ALB and only allow app traffic from the ALB to ECS tasks

## Security-Conscious Defaults

The Terraform code intentionally avoids common IaC weaknesses:

- No hardcoded credentials or secrets
- TLS enforced for S3 access
- S3 public access disabled
- S3 versioning enabled for log retention resilience
- ECS tasks deployed in private subnets
- ALB listener restricted to HTTPS
- ECS task definition uses `readonlyRootFilesystem`
- IAM execution role uses AWS-managed least-privilege execution policy instead of inline wildcard permissions

## GitHub Actions Workflow

The workflow `.github/workflows/iac-scan.yml` performs:

1. `terraform init -backend=false`
2. `terraform validate`
3. **Checkov** scan against `terraform/`
4. **TFSec** scan against `terraform/`
5. Upload of SARIF/artifact outputs for review in GitHub

## Interpreting Checkov Results

Checkov reports policy violations by resource and control ID.

Typical result categories:

- **LOW**: informational hardening gaps
- **MEDIUM**: missing recommended controls
- **HIGH/CRITICAL**: exploitable misconfigurations such as public exposure, missing encryption, or overly permissive IAM/network rules

When reviewing Checkov output:

1. Identify the failing resource and policy ID
2. Read the policy description
3. Confirm whether the finding is valid in the deployment context
4. Remediate in Terraform rather than suppressing unless there is a documented exception

Examples of remediations:

- Add encryption blocks to storage resources
- Add public access blocks to S3
- Restrict security group ingress CIDRs
- Move workloads from public to private subnets
- Replace HTTP listeners with HTTPS

## Interpreting TFSec Results

TFSec focuses on Terraform-specific security issues and highlights:

- insecure defaults
- missing encryption
- public exposure
- weak network boundaries
- logging and monitoring gaps

Recommended triage flow:

1. Review severity and affected resource
2. Compare with Terraform intent
3. Fix the root cause in code
4. Re-run validation and scans

## Remediation Guidance

If future findings appear, prioritize fixes in this order:

1. **Internet exposure** - open security groups, public workloads, plaintext listeners
2. **Data protection** - missing encryption, public buckets, missing TLS enforcement
3. **Identity and access** - wildcard IAM permissions, unnecessary roles
4. **Observability** - missing logs, retention, or auditability
5. **Resilience** - missing versioning, health checks, or multi-AZ placement

## Expected Outcome

With the current Terraform design, Checkov and TFSec should primarily validate that:

- storage is encrypted and non-public
- traffic is TLS-terminated
- workloads are not directly exposed
- logging is enabled
- network segmentation is present

Any remaining warnings should be reviewed as architecture trade-offs rather than ignored blindly.