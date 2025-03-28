output "public_Ec2_instance_public_ip" {
  value = aws_instance.public_Ec2_instance.public_ip
} 
output "public_Ec2_instance2_public_ip" {
  value = aws_instance.public_Ec2_instance2.public_ip
}
output "private_Ec2_instance_private_ip" {
  value = aws_instance.private_Ec2_instance.private_ip
}
