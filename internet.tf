# ref: https://medium.com/@kuldeep.rajpurohit/vpc-with-public-and-private-subnet-nat-on-aws-using-terraform-85a18d17c95e
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge(local.tags, {Name="${var.name}-public"})
  map_public_ip_on_launch = true
}

# internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = "${var.name}-ig" })
}

resource "aws_route_table" "internet-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(local.tags, { Name = "${var.name}-rt" })
}

resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.internet-route-table,
  ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.internet-route-table.id
}

# elastic ip
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = merge(local.tags, {Name="${var.name}-eip"})
}

# NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_eip.elastic_ip,
  ]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id


  tags = merge(local.tags, { Name = "${var.name}-nat-gateway" })
}

resource "aws_route_table" "NAT_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_nat_gateway.nat_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(local.tags, { Name = "${var.name}-nat-rt" })
}

# associate route table to private subnet
resource "aws_route_table_association" "associate_routetable_to_private_subnet" {
  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.NAT_route_table,
  ]
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.NAT_route_table.id
}