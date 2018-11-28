resource "aws_instance" "db_master" {
  ami                     = "${var.amis["mysql_server"]}"
  instance_type           = "${var.instance_types["mysql_server_master"]}"
  vpc_security_group_ids  = ["${aws_security_group.mysql_server.id}"]
  subnet_id               = "${aws_subnet.private_subnet1.id}"
  disable_api_termination = true
  monitoring              = true
  tags                    = "${var.tags}"
}

resource "aws_instance" "db_slave1" {
  ami                     = "${var.amis["mysql_server"]}"
  instance_type           = "${var.instance_types["mysql_server_slave"]}"
  vpc_security_group_ids  = ["${aws_security_group.mysql_server.id}"]
  subnet_id               = "${aws_subnet.private_subnet2.id}"
  ebs_optimized           = true
  disable_api_termination = true
  monitoring              = true
  tags                    = "${var.tags}"
}

resource "aws_security_group" "mysql_server" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${var.tags}"

  ingress {
    description     = "TCP"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web_server.id}"]
  }
  
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.nat.id}"]
  }
}

resource "aws_ebs_volume" "db_slave1" {
  availability_zone = "${aws_subnet.private_subnet2.availability_zone}"
  size              = 950
}

resource "aws_volume_attachment" "db_slave1" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.db_slave1.id}"
  instance_id = "${aws_instance.db_slave1.id}"
}
