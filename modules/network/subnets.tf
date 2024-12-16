data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "pub_subnet" {
  count = length(var.public_subet)
  vpc_id = aws_vpc.this.id
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index%length(data.aws_availability_zones.available.zone_ids)]
  map_public_ip_on_launch = true
  cidr_block = var.public_subet[count.index]
  tags = {
    Name="${var.environment}-public-subnet-${count.index+1}"
  }
}
resource "aws_subnet" "pri_subnet" {
  count = length(var.private_subnet)
  availability_zone_id =data.aws_availability_zones.available.zone_ids[count.index%length(data.aws_availability_zones.available.zone_ids)]
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet[count.index]
  tags = {
    Name="${var.environment}-private-subnet-${count.index+1}"
  }
}