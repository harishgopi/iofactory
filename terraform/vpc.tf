resource "aws_vpc" "ionginx-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "ionginx-gateway" {
    vpc_id = "${aws_vpc.ionginx-vpc.id}"
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.ionginx-vpc.id}"

    tags {
        Name = "NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-30913f47" 
    availability_zone = "us-east-2a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}

/*
  Public Subnet
*/

resource "aws_subnet" "public" {
  count = "${length(var.subnet_cidrs_public)}"

  vpc_id = "${aws_vpc.ionginx-vpc.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "us-east-2a"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.subnet_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}



/*
  Private Subnet
*/

resource "aws_subnet" "private" {
  count = "${length(var.subnet_cidrs_private)}"

  vpc_id = "${aws_vpc.ionginx-vpc.id}"
  cidr_block = "${var.subnet_cidrs_private[count.index]}"
  availability_zone = "us-east-2a"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.subnet_cidrs_private)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
