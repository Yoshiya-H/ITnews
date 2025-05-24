resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskexecutionRole"
  assume_role_policy = file("./ecsTaskexecutionRole_assume_role_policy.json")
  tags = {
    Name = "ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}