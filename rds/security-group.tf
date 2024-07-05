module "db_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.9.0"
  name        = "${var.cluster_identifier}-sg"
  vpc_id      = data.terraform_remote_state.vpc_state.outputs.vpc_id
  description = "Security group for ${var.cluster_identifier}"
  # ingress_cidr_blocks      = var.ingress_cidr_blocks
  ingress_with_cidr_blocks = [
    {
      rule = "postgresql-tcp"
      #     cidr_blocks = "${var.vpc_cidr_block},${var.vpn_cidr}"
      cidr_blocks = "0.0.0.0/0" #"${data.terraform_remote_state.vpc_state.outputs.vpc_cidr_block}"
    },
  ]
  egress_rules = ["all-all"]
  tags         = merge(var.resource_tags, { "Name" : "${var.cluster_identifier}-sg" })
}
