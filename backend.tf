terraform {
  backend "s3" {
    bucket         = "terraform-state-thierno-lab"
    key            = "lab04/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
