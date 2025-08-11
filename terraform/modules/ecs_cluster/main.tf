#Create ECS Cluster
resource "aws_ecs_cluster" "udemy_devops_ecs_cluster" {
  name = "final-assignment-ecs-cluster"
  
}
#Create ECS Task Execution Role
resource "aws_iam_role" "task_execution_role" {
  name = "final-assignment-task-execution-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "task_execution_policy" {
  name        = "final-assignment-task-execution-policy"
  description = "Policy for ECS task execution role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "task_execution_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_policy.arn
}

#Create ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "final-assignment-task-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_policy" "ecs_task_role_policy" {
  name        = "final-assignment-task-role-policy"
  description = "Policy for ECS task role"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "secretmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

####### Frontend ######
resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name = "ecs/ecs/final-assignment-fe"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "frontend_task_definition" {
  family                   = "frontend-task-definition"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "512"
  memory                = "1024"
  container_definitions = <<DEFINITION
  [
    {
      "name": "nodejs-container",
      "image": "${var.frontend_ecr_image_url}",
      "environment": [
        {
          "name": "REACT_APP_API_URL",
          "value": "${var.alb_dns}"
        }
      ],
      "cpu": 512,
      "memory": 1024,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.frontend_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "nodejs-container"
        }
      }
    }
  ]
  DEFINITION
}


resource "aws_ecs_service" "frontend_service" {
  name            = "final-assignment-fe"
  network_configuration {
    subnets = var.ecs_subnet_ids
    security_groups = var.ecs_security_group_ids
    assign_public_ip = true
  }
  cluster         = aws_ecs_cluster.udemy_devops_ecs_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.frontend_target_group_arn
    container_name   = "nodejs-container"
    container_port   = 3000
  }

}

####### Backend ######
resource "aws_cloudwatch_log_group" "backend_log_group" {
  name = "ecs/final-assignment-be"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = "backend-task-definition"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "512"
  memory                = "1024"
  container_definitions = <<DEFINITION
  [
    {
      "name": "java-container",
      "image": "${var.backend_ecr_image_url}",
      "cpu": 512,
      "memory": 1024,
      "secrets": [
        {
          "name": "MONGO_URL",
          "valueFrom": "${var.mongodb_connection_string_secret_arn}"
        }
      ],
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.backend_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "nodejs-container"
        }
      }
    }
  ]
  DEFINITION
}


resource "aws_ecs_service" "backend_service" {
  name            = "final-assignment-be"
  network_configuration {
    subnets = var.ecs_subnet_ids
    security_groups = var.ecs_security_group_ids
    assign_public_ip = true
  }
  cluster         = aws_ecs_cluster.udemy_devops_ecs_cluster.id
  task_definition = aws_ecs_task_definition.backend_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.backend_target_group_arn
    container_name   = "java-container"
    container_port   = 8080
  }

}
