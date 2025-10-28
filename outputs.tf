output "public_ip" {
  value = aws_instance.spring_app.public_ip
}

output "key_pair_name" {
  value = aws_key_pair.generated_key.key_name
}

output "private_key_path" {
  value = local_file.private_key.filename
}
