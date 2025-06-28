# ECRリポジトリの作成 (Python)
resource "aws_ecr_repository" "python_app_repo" {
  name = var.python_ecr_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECRリポジトリの作成 (PHP)
resource "aws_ecr_repository" "php_app_repo" {
  name = var.php_ecr_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECSクラスタの作成
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}