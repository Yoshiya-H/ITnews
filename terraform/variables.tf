variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "python_ecr_repo_name" {
  type = string
  description = "Name of the ECR repository for Python backend"
}

variable "php_ecr_repo_name" {
  type = string
  description = "Name of the ECR repository for PHP frontend"
}

variable "ecs_cluster_name" {
  type = string
}

variable "github_token" {
  type = string
  description = "Github Personal Access Token"
  sensitive = true
}
