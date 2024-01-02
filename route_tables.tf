# Create private route table
resource "aws_route_table" "private-rtb" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.tags,

      { 
        name = format("%s-private-route-table", var.name)
      }
    )
  
}

# Associate all private subnets to the private route tables.

resource "aws_route_table_association" "private_subnets_assoc" {
    count = length(aws_subnet.Private[*].id)
    subnet_id = element(aws_subnet.Private[*].id, count.index)
    route_table_id = aws_route_table.private-rtb.id
  
}

# Create public route table

resource "aws_route_table" "public-rtb" {
    vpc_id = aws_vpc.main.id

    tags = merge (
        var.tags,

        {
            name = format("%s-public-route-table", var.name)
        }
    )
   
}
  

# Associate all public subnets to public route table

resource "aws_route_table_association" "public_subnets_assoc" {
    count = length(aws_subnet.public[*].id)
    subnet_id = element(aws_subnet.public[*].id,count.index)
    route_table_id = aws_route_table.public-rtb.id
  
}

# Create route for the public route-table and attach  it tobthe internet gateway

resource "aws_route" "public-rtb-route" {
    route_table_id = aws_route_table.public-rtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}
