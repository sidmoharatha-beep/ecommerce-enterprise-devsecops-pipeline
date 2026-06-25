variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "juice-shop"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.42.0.0/16"
}

variable "allowed_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the HTTPS listener."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "container_image" {
  description = "Container image URI for the Juice Shop workload."
  type        = string
  default     = "bkimminich/juice-shop:latest"
}

variable "container_port" {
  description = "Application container port."
  type        = number
  default     = 3000
}

variable "task_cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of running tasks."
  type        = number
  default     = 1
}

variable "domain_name" {
  description = "DNS name for the ACM certificate and ALB listener."
  type        = string
}