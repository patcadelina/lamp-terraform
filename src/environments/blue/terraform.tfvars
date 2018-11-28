tags = {
  environment = "blue"
}

private_subnet1_cidr_block = "192.168.2.0/24"
private_subnet2_cidr_block = "192.168.4.0/24"
public_subnet1_cidr_block = "192.168.1.0/24"
public_subnet2_cidr_block = "192.168.3.0/24"

region = "eu-west-1"

vpc_cidr_block = "192.168.0.0/16"

amis = {
  mysql_server = "ami-0a3e4c3998bcf1e8c"
  nat_server   = "ami-024107e3e3217a248"
  web_server   = "ami-015a01e69314a30cd"
}
instance_types = {
  mysql_server_master = "i3.xlarge"
  mysql_server_slave  = "i3.xlarge"
  nat_server          = "m5.large"
  web_server          = "m5.large"
}

asg_min_size = 1
asg_max_size = 3

# TODO: Replace with organization IP CIDR
office_cidrs = "0.0.0.0/0"
