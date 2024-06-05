terraform {
  backend "s3" {
    bucket         = "state-file" 
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}