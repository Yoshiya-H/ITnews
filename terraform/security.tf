# Security group for ALB
resource "aws_security_group" "alb_sg" {
  name = "ecs-alb-sg"
  description = "Allow HTTP trafic from the internet"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "Allow HTTP from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecs-alb-sg"
  }
}

# Security group for ECS task
resource "aws_security_group" "ecs_sg" {
  name = "ecs-ecs-sg"
  description = "Allow trafic from ALB"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "Allow trafic from ALB SG"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.alb_sg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  tags = {
    Name = "ecs-ecs-sg"
  }
}