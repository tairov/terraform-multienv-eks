output "vpc_id" {
  value = aws_vpc.vpc-1.id
}
output "public_subnet_1_id" {
  value = aws_subnet.public-subnet-1.id
}
output "public_subnet_2_id" {
  value = aws_subnet.public-subnet-2.id
}
output "private_subnet_1_id" {
  value = aws_subnet.private-subnet-1.id
}
output "private_subnet_2_id" {
  value = aws_subnet.private-subnet-2.id
}
output "public_route_table_id" {
  value = aws_route_table.public-route-table.id
}
output "private_route_table_id" {
  value = aws_route_table.private-route-table.id
}
output "nat_gw_eip" {
  value = aws_eip.nat-gw-eip
}
output "nat_gw_id" {
  value = aws_nat_gateway.nat-gw.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.internet-gateway.id
}
output "internet_gateway_arn" {
  value = aws_internet_gateway.internet-gateway.arn
}
