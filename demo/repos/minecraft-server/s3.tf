resource "aws_s3_bucket" "backup" {
  bucket_prefix = "waypoint-${var.waypoint_application}"

  force_destroy = true
}
