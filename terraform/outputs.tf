output "vpc_id" {
  description = "ID of the application VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the load balancer."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  value       = aws_subnet.private[*].id
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.app.dns_name
}

output "logs_bucket_name" {
  description = "S3 bucket used for ALB access logs."
  value       = aws_s3_bucket.logs.bucket
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.main.name
}