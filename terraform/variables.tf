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