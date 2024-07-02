
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "terraform_remote_state" "vpc_state" {
  backend = "s3"
  config = {
    bucket         = var.data_vpc_state_bucket
    key            = var.data_vpc_state_key
    region         = var.data_vpc_state_region
    dynamodb_table = var.data_vpc_state_dynamodb_table
    profile        = var.data_vpc_state_profile
  }
}

