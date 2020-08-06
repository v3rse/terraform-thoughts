provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

locals {
  build_directory_path  = "${path.module}/../dist"
  lambda_functions_path = "${path.module}/../src/functions"

  # lambda source paths
  webhook_handler_path = "${local.lambda_functions_path}/webhook-handler"

  # lambda output paths
  webhook_handler_zip_name = "${local.build_directory_path}/webhook_handler.zip"
}

# lambda deployment packages
data "archive_file" "webhook_handler_lambda_package" {
  type        = "zip"
  source_dir  = local.webhook_handler_path
  output_path = local.webhook_handler_zip_name
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  path        = "/"
  description = "IAM policy for lambda (CloudWatch, SQS)"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage",
        "sqs:GetQueueUrl"
      ],
      "Resource": "arn:aws:sqs:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "webhook_handler" {
  filename         = local.webhook_handler_zip_name
  function_name    = "webhookHandler"
  source_code_hash = data.archive_file.webhook_handler_lambda_package.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  publish          = true
  handler          = "index.handler"
  runtime          = "nodejs12.x"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]
}
