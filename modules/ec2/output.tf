output "instance_subnet_id" {
  value = aws_instance.instance.subnet_id
}

output "instance_public_ip" {
  value = aws_instance.instance.public_ip
}

output "instance_zone" {
  value = aws_instance.instance.availability_zone
}

output "instance_id" {
  value = aws_instance.instance.id
}