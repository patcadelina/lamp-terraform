resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  tags       = "${var.tags}"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet1_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  tags                    = "${var.tags}"
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet1_cidr_block}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags              = "${var.tags}"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet2_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  tags                    = "${var.tags}"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet2_cidr_block}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags              = "${var.tags}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"
}

resource "aws_route_table" "rt1" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags   = "${var.tags}"
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = "${aws_subnet.public_subnet1.id}"
  route_table_id = "${aws_route_table.rt1.id}"
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = "${aws_subnet.public_subnet2.id}"
  route_table_id = "${aws_route_table.rt1.id}"
}

resource "aws_network_acl" "public" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"

  ingress {
    rule_no    = 50
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    rule_no    = 150
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "${var.office_cidrs}"
  }

  egress {
    rule_no    = 200
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "${aws_subnet.private_subnet1.cidr_block}"
  }

  egress {
    rule_no    = 250
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "${aws_subnet.private_subnet2.cidr_block}"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"
  
  ingress {
    rule_no    = 300
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "${aws_vpc.main.cidr_block}"
  }

  ingress {
    rule_no    = 350
    action     = "allow"
    protocol   = "tcp"
    from_port  = 3306
    to_port    = 3306
    cidr_block = "${aws_vpc.main.cidr_block}"
  }

  ingress {
    rule_no    = 400
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "${aws_subnet.public_subnet1.cidr_block}"
  }

  ingress {
    rule_no    = 450
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "${aws_subnet.public_subnet2.cidr_block}"
  }

  egress {
    rule_no    = 500
    action     = "allow"
    protocol   = -1
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }
}
