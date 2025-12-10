output "instance_public_ip" {
  description = "Public IP of the Strapi EC2 instance"
  value = aws_instance.strapi.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the Strapi EC2 instance"
  value = aws_instance.strapi.public_dns
}

output "application_url" {
  description = "URL to access Strapi application"
  value = "http://${aws_instance.strapi.public_ip}:1337"
}

output "admin_url" {
  description = "URL to access Strapi admin panel"
  value = "http://${aws_instance.strapi.public_ip}:1337/admin"
}
