resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "ebs_csi_driver_role_policy_attachment" {
  name       = "ebs_csi_driver_role_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  roles      = [aws_iam_role.ebs_csi_driver_role.name]
}
