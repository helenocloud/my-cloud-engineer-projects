data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220805.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazonlinux.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "mykey"
  vpc_security_group_ids     = [aws_security_group.public.id]
  subnet_id                   = aws_subnet.public[0].id

  tags = {
    Name = "${var.env_code}-public"
  }
}

resource "aws_security_group" "public" {
  name        = "${var.env_code}-public"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from public"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["72.83.207.196/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-public"
  }
}