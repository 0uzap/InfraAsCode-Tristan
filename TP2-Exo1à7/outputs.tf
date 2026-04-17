output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i deployer-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "bucket_id" {
  description = "identifiant du bucket de la ressource aws_s3_bucket.demo_bucket"
  value       = aws_s3_bucket.demo_bucket.id
}

output "s3_object_url" {
  description = "URL publique de l'objet S3"
  value       = "https://${aws_s3_bucket.demo_bucket.bucket}.s3.amazonaws.com/${aws_s3_object.demo_object.key}"
}

output "wordpress_url" {
  description = "URL de wordpress"
  value       = "https://${aws_instance.web.public_ip}"
}
