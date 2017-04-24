variable "azs" {
    default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1e"]
}

# The number of public/private subnets to have.
variable "subnets" {
    default = 4
}

variable "cidr" {
    default = "10.0.0.0/16"
}


resource "aws_vpc" "main" {
    cidr_block = "${var.cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Application = "${var.app}"
        Environment = "${var.env}"
        Name = "${var.app}/${var.env} VPC"
    }
}

resource "aws_subnet" "public" {
    count = "${var.subnets}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${cidrsubnet(var.cidr, 8, count.index)}"
    map_public_ip_on_launch = true
    availability_zone = "${element(var.azs, count.index % length(var.azs))}"

    tags {
        Name = "${var.app}/${var.env} public ${element(var.azs, count.index % length(var.azs))}"
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_subnet" "private" {
    count = "${var.subnets}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${cidrsubnet(var.cidr, 8, var.subnets + count.index)}"
    map_public_ip_on_launch = false
    availability_zone = "${element(var.azs, count.index % length(var.azs))}"

    tags {
        Name = "${var.app}/${var.env} private ${element(var.azs, count.index % length(var.azs))}"
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "${var.app}/${var.env} Gateway"
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "${var.app}/${var.env} Public Route Table"
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_route" "public_gw" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "public" {
    count = "${var.subnets}"
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
    depends_on = ["aws_subnet.public"]
}

resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public.0.id}"
    depends_on = ["aws_internet_gateway.gw", "aws_subnet.public"]
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "${var.app}/${var.env} Private Route Table"
        Application = "${var.app}"
        Environment = "${var.env}"
    }
}

resource "aws_route" "private_gw" {
    route_table_id = "${aws_route_table.private.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "private" {
    count = "${var.subnets}"
    subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
    depends_on = ["aws_subnet.private"]
}
