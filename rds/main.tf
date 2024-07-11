

resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version #"5.7"
  instance_class =var.instance_class
  identifier = var.db_name
  username = var.username
  password = var.password
  publicly_accessible  = var.publicly_accessible 
  vpc_security_group_ids = [module.db_sg.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot = true
}
resource "aws_db_subnet_group" "default" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc_state.outputs.private_subnets #data.terraform_remote_state.vpc.outputs.db_subnets
  tags       = merge(var.resource_tags, { "Name" : "${var.cluster_identifier}" })
}