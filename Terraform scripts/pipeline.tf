# code commit repository
resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = "Notification_service"
  description = "Stores source code of notification service"
}

#ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "repo-notification.123"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true 
  }
}

#code build project
resource "aws_codebuild_project" "codebuild_service" {
    name = "notification_service_buid"
    description = "Build project for notification service app"
    service_role = aws_iam_role.codebuild_role.arn

     artifacts {
      type = "NO_ARTIFACTS"
    }
    source {
      type            = "CODECOMMIT"
      location        = aws_codecommit_repository.codecommit_repo.clone_url_http
      buildspec       = local_file.buildspec.filename
      git_clone_depth = 1
    }
    environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }
  cache {
    type = "NO_CACHE"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}