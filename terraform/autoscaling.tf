data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "launch_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "example" {
    vpc_zone_identifier = ["${aws_subnet.pvt-subnet1.id}", "${aws_subnet.pvt-subnet2.id}","${aws_subnet.pvt-subnet3.id}"]
    min_size = 2
    max_size = 4
    name                 = "terraform-asg"
    launch_configuration = "${aws_launch_configuration.launch_conf.name}" 

    
    lifecycle {
        create_before_destroy = true
    }

    tag {
        key                 = "Name"
        value               = "io-terraform-asg"
        propagate_at_launch = true
    }
    
    
}
