data "aws_route53_zone" "domain" {
  name = var.domain
}

resource "aws_route53_record" "server" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.waypoint_application}.${var.domain}"
  type    = "A"
  ttl     = 300

  records = [
    aws_instance.server.public_ip,
  ]
}
