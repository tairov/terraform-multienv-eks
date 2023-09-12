terraform {
  backend "s3" {
    bucket         = "terraform-state-multienv-test"
    key            = "multienv-eks/terraform-test.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "multienv-eks-terraform-state-lock"
    encrypt        = true
  }
}
