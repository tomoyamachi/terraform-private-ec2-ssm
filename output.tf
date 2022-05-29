output "instance_id" {
  value = aws_instance.ec2.id
}

output "ssh_commands" {
  value = "ssh -i <key> ec2-user@${aws_instance.ec2.id}"
}
