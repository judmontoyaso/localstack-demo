resource "aws_s3_bucket" "uploads" {
  bucket = "mi-bucket-uploads"
}

resource "aws_dynamodb_table" "usuarios" {
  name         = "Usuarios"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }
}

resource "aws_sqs_queue" "cola" {
  name = "cola-notificaciones"
}

resource "aws_lambda_function" "procesar" {
  filename      = "function.zip"
  function_name = "procesar-eventos"
  role          = "arn:aws:iam::000000000000:role/lambda-role"
  handler       = "index.handler"
  runtime       = "python3.11"
}
