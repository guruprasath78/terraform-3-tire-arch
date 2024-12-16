resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_kp.id
  tags = {
    Name="${var.environment}-igw"
  }
}
resource "aws_eip" "name" {
  count = var.nat_type=="gateway"?1:0
}
resource "aws_nat_gateway" "natg" {
    count = var.nat_type=="gateway"?1:0
  allocation_id = aws_eip.name[0].id
  connectivity_type = "public"
  subnet_id = aws_subnet.pub_subnet[0].id
  tags = {
    Name="${var.environment}-natg"
  }
}
resource "aws_instance" "nat_instance" {
    count = var.nat_type=="instance"?1:0
    subnet_id = aws_subnet.pub_subnet[0].id
    instance_type="t2.micro"
    ami="ami-024cf76afbc833688" #public ami
    source_dest_check = false
    vpc_security_group_ids = [aws_security_group.sg-nat[0].id]
    tags = {
      Name="${var.environment}-nat_instance"
    }
}