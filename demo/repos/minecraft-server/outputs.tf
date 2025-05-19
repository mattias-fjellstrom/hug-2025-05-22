output "public_ip" {
  value = aws_instance.server.public_ip
}

output "public_dns" {
  value = "${var.waypoint_application}.${var.domain}"
}

output "bucket" {
  value = aws_s3_bucket.backup.bucket
}

output "ssh_command" {
  value = "ssh -i server.pem ubuntu@${aws_instance.server.public_ip}"
}
