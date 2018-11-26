resource "aws_instance" "nat1" {
  ami                         = "${var.amis["nat_server"]}"
  instance_type               = "${var.instance_types["nat_server"]}"
  vpc_security_group_ids      = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.ssh.id}"
  ]
  subnet_id                   = "${var.public_subnet1_cidr_block}"
  associate_public_ip_address = true
  disable_api_termination     = true
  source_dest_check           = false
  tags                        = "${var.tags}"
}

resource "aws_instance" "nat2" {
  ami                         = "${var.amis["nat_server"]}"
  instance_type               = "${var.instance_types["nat_server"]}"
  vpc_security_group_ids      = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.ssh.id}"
  ]
  subnet_id                   = "${var.public_subnet2_cidr_block}"
  associate_public_ip_address = true
  disable_api_termination     = true
  source_dest_check           = false
  tags                        = "${var.tags}"
}

resource "aws_security_group" "nat" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"

  egress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.office_cidrs}"]
  }

  egress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.web_server.id}",
      "${aws_security_group.mysql_server.id}",
    ]
  }
}

resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat1.id}"
  }
  
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat2.id}"
  }

  tags   = "${var.tags}"
}

resource "aws_route_table_association" "nat1" {
  subnet_id      = "${aws_subnet.private_subnet1.id}"
  route_table_id = "${aws_route_table.nat.id}"
}

resource "aws_route_table_association" "nat2" {
  subnet_id      = "${aws_subnet.private_subnet2.id}"
  route_table_id = "${aws_route_table.nat.id}"
}