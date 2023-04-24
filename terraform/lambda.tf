data "archive_file" "lambda-get-zip" {
  type        = "zip"
  output_path = "../lambda-get.zip"
  source_file = "../lambda_get_function.py"
}

resource "aws_lambda_function" "lambda-get-function" {
  filename         = data.archive_file.lambda-get-zip.output_path
  source_code_hash = data.archive_file.lambda-get-zip.output_base64sha256
  function_name    = "crc-lambda-get"
  role             = aws_iam_role.lambda-get-role.arn
  handler          = "lambda_get_function.lambda_handler"
  runtime          = "python3.7"
}


resource "aws_iam_policy" "get-dynamodb-policy" {
  name        = "crc-lambda-get-dynamodb-policy"
  description = "Policy for crc-lambda-get role to manage crc-counter dynamodb."
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.crc_counter.arn}",
      "Effect": "Allow",
      "Sid": "AllowReadDynamoDb"
    }
  ]
}
POLICY
}


resource "aws_iam_role" "lambda-get-role" {
  name = "crc-lambda-get-role"

  assume_role_policy = <<POLICY
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
POLICY
}


resource "aws_iam_role_policy_attachment" "lambda-get-dynamodb-policy-attach" {
  role       = aws_iam_role.lambda-get-role.name
  policy_arn = aws_iam_policy.get-dynamodb-policy.arn
}