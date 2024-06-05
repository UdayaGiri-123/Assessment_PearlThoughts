resource "aws_cloudwatch_log_group" "notification_cluster_logs" {
  name = "notification_service"
}

resource "aws_ecs_cluster" "cluster_service" {
  name = "notification-service"
  configuration {
    execute_command_configuration {
    
    log_configuration {
        cloud_watch_encryption_enabled = true   
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.notification_cluster_logs.name
      }
  }
  }
}

resource "aws_ecs_task_definition" "notification_task" {
family = "notificarion_service"
network_mode = "awsvpc" 
requires_compatibilities = ["FARGATE"]
cpu                      = "256"
memory                   = "512"
container_definitions = jsonencode([
    {
        name = "notification"
        image     = "${aws_ecr_repository.notification.repository_url}/notification:latest"
        essential = true
        portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }]
    },
    {
        name = "email"
        image     = "${aws_ecr_repository.notification.repository_url}/email:latest"
        essential = true
    }
  
])
}