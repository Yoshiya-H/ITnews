resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-service-role"
  assume_role_policy = file("codepipelineRole_assume_role_policy.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-inline-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = templatefile(
    "./codepipelineInlinePolicy.json",
    {
      codestar_connections_arn = aws_codestarconnections_connection.github.arn
    }
  )
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "ecs-app-codepipeline-artifacts"
  force_destroy = true
}

resource "aws_codestarconnections_connection" "github" {
  name = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "app_pipeline" {
  name = "ecs_app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type = "S3"
  }
  
  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "Yoshiya-H/ITnews"
        BranchName = "main"
      }
    }
  }
  
  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      input_artifacts = ["build_output"]
      version = "1"
      configuration = {
        ClusterName = aws_ecs_cluster.app_cluster.name
        ServiceName = aws_ecs_service.ecs_app.name
        FileName = "imagedefinitions.json"
      }
    }
  }
}