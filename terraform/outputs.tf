output "python_app_repo_url" {
  value = aws_ecr_repository.python_app_repo.repository_url
}

output "php_app_repo_url" {
  value = aws_ecr_repository.php_app_repo.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "codestar-connections" {
  value = aws_codestarconnections_connection.github.name
  description = <<EOT
  The aws_codestarconnections_connection resource is created in the state PENDING. 
  Authentication with the connection provider must be completed in the AWS Console.
  https://console.aws.amazon.com/codesuite/settings/connections
  EOT
}