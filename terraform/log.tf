resource "aws_cloudwatch_log_group" "frontend_php" {
  name              = "/ecs/frontend/php"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_group" "backend_python" {
  name              = "/ecs/backend/python"
  retention_in_days = 5
}