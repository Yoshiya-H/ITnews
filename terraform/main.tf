# ECRリポジトリの作成
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECSクラスタの作成
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}
