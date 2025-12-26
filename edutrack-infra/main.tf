provider "aws" {
  region = "us-east-1"
}

# ECR Repository

resource "aws_ecr_repository" "lms_repo" {
  name = "lms/delli-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# VPC

resource "aws_vpc" "lms_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lms-vpc"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "lms_igw" {
  vpc_id = aws_vpc.lms_vpc.id

  tags = {
    Name = "lms-igw"
  }
}

# public subnet

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.lms_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "lms-public-a"
  }
}

# route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lms_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms_igw.id
  }

  tags = {
    Name = "lms-public-rt"
  }
}

# ECS cluster

resource "aws_ecs_cluster" "lms_cluster" {
  name = "lms-practice-cluster"
}

# IAM role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Taskdefinitions

resource "aws_ecs_task_definition" "lms_task" {
  family                   = "lms-practice-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "lms-main-app"
      image = "${aws_ecr_repository.lms_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/lms-practice-task"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# security group

resource "aws_security_group" "ecs_sg" {
  name   = "ecs-lms-sg"
  vpc_id = aws_vpc.lms_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # learning only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS service

resource "aws_ecs_service" "lms_service" {
  name            = "lms-practice-service"
  cluster         = aws_ecs_cluster.lms_cluster.id
  task_definition = aws_ecs_task_definition.lms_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
