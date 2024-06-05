resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 10  # Maximum number of tasks
  min_capacity       = 1   # Minimum number of tasks
  resource_id        = "service/${aws_ecs_cluster.cluster_service.name}/${aws_ecs_service.ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
    
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName  = aws_ecs_cluster.cluster_service.name
    ServiceName  = aws_ecs_service.ecs-service.name
  }

  alarm_description = "This metric monitors ECS service CPU usage"

  alarm_actions = [
    aws_appautoscaling_policy.scale_up.arn
  ]
}


