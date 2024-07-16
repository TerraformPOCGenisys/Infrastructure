
resource "aws_security_group" "ingress" {
  name        = "${var.eks_cluster_name}-sg"
  description = "${var.eks_cluster_name}-sg"
  vpc_id      = data.terraform_remote_state.vpc_state.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs_sg
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs_sg
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.eks_cluster_name}-sg"
  }
}