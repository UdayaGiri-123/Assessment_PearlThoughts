# Buildspec file
resource "local_file" "buildspec" {
  content = <<EOF
version: 0.2

# env:
#   variables:
#     CODEBUILD_RESOLVED_SOURCE_VERSION: "1.0"

phases:
  install:
    runtime-versions:
      node:18-alpine

  pre_build:
    commands:
      - npm i ./package.json
  build:
    commands:
      - docker build -t ${aws_ecr_repository.ecr_repo.repository_url}:latest .
      - docker tag ${aws_ecr_repository.ecr_repo.repository_url}:latest ${aws_ecr_repository.ecr_repo.repository_url}:$CODEBUILD_RESOLVED_SOURCE_VERSION
  post_build:
    commands:
      - docker push ${aws_ecr_repository.ecr_repo.repository_url}:latest
      - docker push ${aws_ecr_repository.ecr_repo.repository_url}:$CODEBUILD_RESOLVED_SOURCE_VERSION

EOF
  filename = "${path.module}/buildspec.yml"
}