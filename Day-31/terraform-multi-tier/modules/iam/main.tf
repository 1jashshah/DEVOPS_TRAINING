resource "aws_iam_role" "instance_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "${var.role_name}-policy-attachment"
  roles      = [aws_iam_role.instance_role.name]
  policy_arn  = var.policy_arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.instance_role.name
}