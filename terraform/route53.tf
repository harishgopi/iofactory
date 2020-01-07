resource "aws_route53_zone" "example" {
  name = "test.example.com"
}

resource "aws_route53_record" "example" {
  zone_id = "${aws_route53_zone.example.zone_id}"
  name    = "example.in"
  type    = "A"
  ttl     = "5"
  records = ["aws_eip.nat.public_ip"]
}
