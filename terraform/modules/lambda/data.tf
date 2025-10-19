data "archive_file" "lambda" {
  type = "zip"

  source_file = "${var.lambda_dist_folder_path}/index.mjs"
  output_path = "${var.lambda_dist_folder_path}/function.zip"
}


data "aws_iam_policy_document" "lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_s3" {
  statement {
    sid     = "S3BucketAccess"
    effect  = "Allow"
    actions = ["s3:PutObject"]

    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]

  }
}

data "aws_iam_policy_document" "lambda_kms" {
  statement {
    sid    = "KMSAccess"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey"
    ]

    resources = [var.bucket_kms_key_arn]
  }
}
