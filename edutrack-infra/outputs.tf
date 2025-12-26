output "ecr_repository_url" {
  description = "ECR repository URL for Docker images"
  value       = aws_ecr_repository.lms_repo.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.lms_cluster.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.lms_service.name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS"
  value       = aws_lb.lms_alb.dns_name
}
