variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "ecr_repo_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_image_url" {
  description = "URL of the Docker image in ECR (e.g., 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest)"
  type = string
  validation {
    condition = can(regex("^[0-9]+\\.dkr\\.ecr\\.[a-z0-9-]+\\.amazonaws\\.com/.+:.+$", var.ecs_image_url))
    error_message = "The ecs_image_url must be a valid ECR repository URL format."
  }
}