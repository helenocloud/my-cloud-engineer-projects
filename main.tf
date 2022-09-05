resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.env_code 
  }  
}


resource "aws_subnet" "public0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

   tags = {
    Name = "${var.env_code}-public0" 
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  
   tags = {
    Name = "${var.env_code}-public1" 
  }
}

resource "aws_subnet" "private0" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.env_code}-private0" 
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "${var.env_code}-private1" 
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_code}-main" 
  }
}

resource "aws_eip" "nat0" {
  vpc      = true

  tags = {
    Name = "${var.env_code}-nat0" 
  }
}

resource "aws_eip" "nat1" {
  vpc      = true

  tags = {
    Name = "${var.env_code}-nat1" 
  }
}

resource "aws_nat_gateway" "main0" {
  allocation_id = aws_eip.nat0.id
  subnet_id     = aws_subnet.public0.id

  tags = {
    Name = "${var.env_code}-main0" 
  }
}

resource "aws_nat_gateway" "main1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.env_code}-main1" 
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {            
    cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

   tags = {
    Name = "${var.env_code}-public" 
  }
}

resource "aws_route_table" "private0" {
  vpc_id = aws_vpc.main.id
  
  route {            
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main0.id
  }

  tags = {
    Name = "${var.env_code}-private0" 
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id
  
  route {            
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main1.id
  }

  tags = {
    Name = "${var.env_code}-private1" 
  }
}

resource "aws_route_table_association" "public0" {
  subnet_id      = aws_subnet.public0.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private0" {
  subnet_id      = aws_subnet.private0.id
  route_table_id = aws_route_table.private0.id
  
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id

}