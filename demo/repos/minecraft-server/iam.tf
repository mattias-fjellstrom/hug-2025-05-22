resource "aws_iam_role" "server" {
  name_prefix = "waypoint-minecraft-${var.waypoint_application}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3" {
  name_prefix = "waypoint-minecraft-${var.waypoint_application}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.server.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_instance_profile" "server" {
  name_prefix = "waypoint-minecraft-${var.waypoint_application}"
  role        = aws_iam_role.server.name
}
