data "aws_iam_policy_document" "from_vpc_endpoint_only" {
  statement {
    sid     = "AccessToSpecificVpceOnly"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringNotEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.s3_vpc_endpoint_id}"]
    }
  }
}

# Require SSE KMS
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html#require-sse-kms
data "aws_iam_policy_document" "sse_only" {
  statement {
    sid     = "DenyObjectsThatAreNotSSEKMS"
    effect  = "Deny"
    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "combined_bucket_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.from_vpc_endpoint_only.json,
    data.aws_iam_policy_document.sse_only.json
  ]
}
