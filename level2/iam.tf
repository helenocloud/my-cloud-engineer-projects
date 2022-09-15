resource "aws_iam_role" "main" {
  name        = var.env_code
  description = "EC2 IAM role for SSM access"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : ["ec2.amazonaws.com"]
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "main" {
  role = aws_iam_role.main.name
  name = var.env_code
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

