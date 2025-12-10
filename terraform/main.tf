data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "deployer_key" {
  count      = var.public_key_path != "" ? 1 : 0
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "strapi" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.strapi_subnet.id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = templatefile("${path.module}/../userdata_dockerhub.tpl", {
    IMAGE = var.dockerhub_image
  })

  tags = {
    Name = "strapi-ec2"
  }
}
