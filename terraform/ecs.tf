# ALB
resource "aws_lb" "app_alb" {
  name = "ecs-app-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id, 
    aws_subnet.public_c.id
  ]
  security_groups = [ aws_security_group.alb_sg.id ]
  tags = {
    Name = "ecs-app-alb"
  }
}

# ターゲットグループ (PHPフロントエンド用)
resource "aws_alb_target_group" "alb_tgp" {
  name = "ecs-alb-tgp"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.main.id
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
  tags = {
    Name = "ecs-alb-tgp"
  }
}

# ALB リスナー
resource "aws_alb_listener" "alb_listener_http" {
    load_balancer_arn = aws_lb.app_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.alb_tgp.arn
    }
}

# ECSタスク定義
resource "aws_ecs_task_definition" "ecs_app" {
  family = "app-task"
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile(
    "./ecsTaskdefinition_ecs_app.json",
    {
      python_image_uri = "${aws_ecr_repository.python_app_repo.repository_url}:latest",
      php_image_uri = "${aws_ecr_repository.php_app_repo.repository_url}:latest"
    }
  )
}

#ECSサービス
resource "aws_ecs_service" "ecs_app" {
  name = "app-service"
  cluster = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.ecs_app.arn
  launch_type = "FARGATE"
  desired_count = 1
  network_configuration {
    subnets = [ aws_subnet.public_a.id, aws_subnet.public_c.id ]
    security_groups = [ aws_security_group.ecs_sg.id ]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.alb_tgp.arn
    # ecsTaskdefinition_ecs_app.json 内で定義されたnameと連動
    # imagedefinitions.jsonでもこのnameを使用する
    container_name = "php-frontend"
    container_port = 80
  }
  depends_on = [ aws_alb_listener.alb_listener_http ]
}