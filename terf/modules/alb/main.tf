# 1. 建立 Application Load Balancer
resource "aws_lb" "main" {
  name               = "tf-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = var.public_subnet_ids
  tags = {
    Name = "tf-ecs-alb"
  }
}

# 2. 建立 Target Group (目標群組)
resource "aws_lb_target_group" "ecs_tg" {
  name = "tf-ecs-target-group-v2"
  port        = 80
  protocol    = "HTTP"
  vpc_id = var.vpc_id  
  target_type = "ip" # Fargate 模式必須使用 ip 類型
  lifecycle {
    create_before_destroy = true
  }
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# 3. HTTP Listener (Port 80) -> 自動 301 重導向至 HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }  
}

# 4. HTTPS Listener (Port 443) -> 掛載 ACM 憑證並轉發給 Target Group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  
  # 確保是用剛剛傳進來的變數
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

