resource "aws_security_group" "server" {
  vpc_id = aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.server.id
  description       = "Allow SSH traffic (used for demo purposes only)"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "22"
  to_port           = "22"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rcon" {
  security_group_id = aws_security_group.server.id
  description       = "Allow RCON traffic (e.g. from HCP Terraform)"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "25575"
  to_port           = "25575"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "minecraft" {
  security_group_id = aws_security_group.server.id
  description       = "Allow Minecraft client traffic to server"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "25565"
  to_port           = "25565"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.server.id
  description       = "Allow all egress traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
