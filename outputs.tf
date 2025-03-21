output "cicd_public_ip" {
  value = aws_instance.cicd_machine.public_ip
}

output "prod_public_ip" {
  value = aws_instance.prod_machine.public_ip
}

output "private_key_path" {
  value = local_file.private_key.filename
}
