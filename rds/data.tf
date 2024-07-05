data "terraform_remote_state" "vpc_state" {
  backend = "s3"
  config = {
    bucket         =  var.data_vpc_state_bucket
    key            = var.data_vpc_state_key
    region         = var.data_vpc_state_region
    # profile = var.data_vpc_state_profile
  }
}

