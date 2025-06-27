resource "aws_iam_role" "codebuild_role" {
  name = "codebuildServiceRole"
  assume_role_policy = file("./codebuildServiceRole_assume_role_policy.json")
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuildInlinePolicy"
  role = aws_iam_role.codebuild_role.id
  policy = file("./codebuildInlinePolicy.json")
}

resource "aws_codebuild_project" "app" {
  name = "my-app-build"
  description = "Builds Docker image and pushes to ECR"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:7.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true # Docker build で必須
  }
  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/my-app"
      stream_name = "build-log"
    }
  }
  source {
    type = "GITHUB"
    location = "https://github.com/Yoshiya-H/ITnews.git"
    buildspec = "buildspec.yml"
  }
}