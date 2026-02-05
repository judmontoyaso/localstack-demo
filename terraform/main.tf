terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    sqs      = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    iam      = "http://localhost:4566"
    logs     = "http://localhost:4566"
  }
}

# -------------------------
# S3
# -------------------------
resource "aws_s3_bucket" "uploads" {
  bucket = "mi-bucket-uploads"
}

# -------------------------
# DynamoDB
# -------------------------
resource "aws_dynamodb_table" "usuarios" {
  name         = "Usuarios"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }
}

# -------------------------
# SQS
# -------------------------
resource "aws_sqs_queue" "cola" {
  name = "cola-notificaciones"
}

# -------------------------
# Lambda
# -------------------------
resource "aws_lambda_function" "procesar" {
  function_name = "procesar-eventos"
  filename      = "build/function.zip"
  source_code_hash = filebase64sha256("build/function.zip")

  role    = "arn:aws:iam::000000000000:role/lambda-role"
  handler = "index.handler"
  runtime = "python3.11"

  depends_on = [
    aws_s3_bucket.uploads,
    aws_dynamodb_table.usuarios,
    aws_sqs_queue.cola
  ]
}
