output "nlb_ip" {
  value = aws_lb.nlb-1.dns_name
}

output "alb_dns_name" {
  value = aws_alb.alb-1.dns_name
}
