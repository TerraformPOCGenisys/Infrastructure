output "ecr_id" {
  value = module.ecr[*].repository_registry_id
}