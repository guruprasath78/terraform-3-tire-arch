resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name="${var.environment}-igw"
  }
}
resource "aws_eip" "nat" {
  count = var.nat_type=="gateway"?1:0
}
resource "aws_nat_gateway" "natg" {
    count = var.nat_type=="gateway"?1:0
  allocation_id = aws_eip.nat[0].id
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
    user_data = local.user_data
    iam_instance_profile = aws_iam_instance_profile.nat-instance-profile[0].name
    vpc_security_group_ids = [aws_security_group.sg-nat[0].id]
    tags = {
      Name="${var.environment}-nat_instance"
    }
}
resource "aws_iam_instance_profile" "nat-instance-profile" {
  count = var.nat_type=="instance"?1:0
  name="${var.nat_ssm_role}-nat-instance-profile"
  role = var.nat_ssm_role
}
locals {
  user_data=<<-EOF
#!/bin/bash -x
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
EOF
}