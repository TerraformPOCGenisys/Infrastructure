variable "ecr_repositories" {
  type = list(string)
}

variable "img_tag" {
  type = list(string)
}


variable "resource_tags" {
  type = any
}
variable "profile" {
  type = any
}
variable "aws_region" {
  type = any
}