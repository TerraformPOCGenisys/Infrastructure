module "ecr" {
  source                  = "terraform-aws-modules/ecr/aws"
  count                   = length(var.ecr_repositories)
  repository_name         = var.ecr_repositories[count.index]
  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = [var.img_tag[count.index]],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags                    = var.resource_tags
}