resource "aws_secretsmanager_secret" "ecr_registry" {
  name = "notification_service_ecr_registry"
}

resource "aws_secretsmanager_secret" "ecr_repositry" {
  name = "notification_service_ecr_repository"
}
