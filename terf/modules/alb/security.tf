# 1. ALB 的 Security Group 本體 (固定不變)
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group" # 給它一個全新名稱，避免與舊的撞名
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id = var.vpc_id

  # 加上生命週期保護：先建新，再刪舊
  lifecycle {
    create_before_destroy = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 獨立加 Port 80 規則 (原地套用)
resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# 獨立加 Port 443 規則 (原地套用)
resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# 2. ECS 的 Security Group
resource "aws_security_group" "ecs_sg" {
  name   = "ecs-task-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}