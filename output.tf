#output "ec2_public_ip" {
  #description = "Den publika IP-adressen för EC2-instansen"
  #value       = aws_instance.webserver.public_ip
#}