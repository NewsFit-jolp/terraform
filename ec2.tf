resource "aws_eip" "web" {
  instance = aws_instance.newsfit_webserver.id
  domain   = "vpc"
}

resource "aws_instance" "newsfit_webserver" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.newsfit_vpc_public_subnet_1.id

  key_name               = aws_key_pair.web.id
  vpc_security_group_ids = [aws_security_group.newsfit_sg.id]

  associate_public_ip_address = true

  user_data = file("user_data.sh")

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name = "newsfit_webserver"
  }
}

resource "aws_key_pair" "web" {
  key_name   = "newsfit_key"
  public_key = file("./.ssh/newsfit_key.pub")

}

output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.newsfit_webserver.id
}

output "public_ip" {
  description = "The Public IP of the instance"
  value       = aws_eip.web.public_ip
}