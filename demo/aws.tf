data "aws_caller_identity" "current" {}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "server" {
  key_name   = "hug-waypoint"
  public_key = tls_private_key.server.public_key_openssh
}

resource "local_file" "ssh" {
  filename        = "server.pem"
  file_permission = "0600"
  content         = trimspace(tls_private_key.server.private_key_pem)
}
