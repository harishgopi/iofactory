resource "aws_autoscaling_group" "example" {
    vpc_zone_identifier = ["${aws_subnet.pvt-subnet1.id}", "${aws_subnet.pvt-subnet2.id}","${aws_subnet.pvt-subnet3.id}"]
    min_size = 2
    max_size = 4

    tag {
        key                 = "Name"
        value               = "io-terraform-asg"
        propagate_at_launch = true
    }

}
