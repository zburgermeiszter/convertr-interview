resource "aws_cloudwatch_log_group" "api_gateway" {
  name = "/aws/apigateway/${var.name_prefix}-api"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "${var.name_prefix}-api-gateway-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]

    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/iam-identity-based-access-control-cwl.html
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"] # todo: restrict
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = "${var.name_prefix}-api-gateway-cloudwatch-policy"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

# IAM Role to allow logging API Gateway to send logs to CloudWatch
resource "aws_api_gateway_account" "cloudwatch" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}
