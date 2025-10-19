resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  role          = aws_iam_role.lambda.arn

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = merge(
      {
        BUCKET_NAME = var.s3_bucket_id
      },
      var.environment_variables
    )
  }

  tags = {
    Name = var.function_name
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
}
