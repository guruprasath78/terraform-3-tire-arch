resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route{
   gateway_id = aws_internet_gateway.igw.id
   cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name="${var.environment}-public-route-table"
  } 
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.this.id
  route {
    gateway_id =var.nat_type=="gateway"?aws_nat_gateway.natg[0].id:null
    network_interface_id = var.nat_type=="instance"?aws_instance.nat_instance[0].primary_network_interface_id:null
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name="${var.environment}-private-route-table"
  } 
}

resource "aws_route_table_association" "rta-igw" {
  route_table_id = aws_route_table.public_rt.id
  count = length(var.public_subet)
  subnet_id = aws_subnet.pub_subnet[count.index].id
}
resource "aws_route_table_association" "rta-natg" {
  route_table_id = aws_route_table.private-rt.id
  count = length(var.private_subnet)
  subnet_id = aws_subnet.pri_subnet[count.index].id
}