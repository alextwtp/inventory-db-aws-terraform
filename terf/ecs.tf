# 1. Build ECS Task Execution IAM Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role-v2"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# 附加上 AWS 官方預設的 ECS Task Execution Policy
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# 2. Build ECS Cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "my-app-cluster"
}


# 3. Define ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "my-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "my-app-container"
      image     = "${aws_ecr_repository.app_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}


# 4. Build ECS Service 
resource "aws_ecs_service" "main" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.main_cluster.id   # 👈 修正：對應 #2 的 main_cluster
  task_definition = aws_ecs_task_definition.app_task.arn # 👈 修正：對應 #3 的 app_task
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = module.vpc.public_subnet_ids
    security_groups = [module.alb.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "my-app-container"
    container_port   = 80
  }

  depends_on = [module.alb.alb_listener_http]
}
