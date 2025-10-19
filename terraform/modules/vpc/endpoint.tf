resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.region}.s3"

  route_table_ids = [aws_route_table.private.id]
  policy          = data.aws_iam_policy_document.s3_vpc_endpoint_policy.json

  tags = {
    Name = "${var.name_prefix}-s3-endpoint"
  }
}

resource "aws_security_group" "lambda" {
  name        = "${var.name_prefix}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = aws_vpc_endpoint.s3.cidr_blocks
    description = "HTTPS to S3 CIDR blocks"
  }

  tags = {
    Name = "${var.name_prefix}-lambda-sg"
  }
}
