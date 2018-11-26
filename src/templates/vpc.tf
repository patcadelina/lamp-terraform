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
