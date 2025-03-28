provider "aws" {
  region = var.region
}

resource "aws_vpc" "APP-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "APP-VPC"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public-subnets" {
  count = 3
  vpc_id = aws_vpc.APP-VPC.id
  cidr_block = cidrsubnet(aws_vpc.APP-VPC.cidr_block, 4, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
      Name = "Public Subnet ${count.index + 1}"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.APP-VPC.id
    tags = {
        Name = "APP-IGW"
    }
}

resource "aws_route_table" "rt-table" {
  vpc_id = aws_vpc.APP-VPC.id   
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt-association" {
  count = 3
  subnet_id = element(aws_subnet.public-subnets[*].id, count.index)
  route_table_id = aws_route_table.rt-table.id

}
resource "aws_security_group" "sg-1" {
  vpc_id = aws_vpc.APP-VPC.id
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*resource "aws_instance" "Ec2-instances" {
  count = 3
  instance_type = var.instance_type
  ami = var.ami
  key_name = var.key_name
  subnet_id = element(aws_subnet.public-subnets[*].id, count.index)
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  user_data = file("user-data.sh")
  tags = {
        Name = "EC2-${count.index + 1}"
    }
}
*/

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = aws_subnet.public-subnets[*].id
  max_size = 5
  min_size = 3
  desired_capacity = 3
  launch_template {
    id = aws_launch_template.launch-temp.id
  }
  tag {
    key = "Name"
    value = "ASG-Instance"
    propagate_at_launch = true
  }  
}

resource "aws_launch_template" "launch-temp" {
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = base64encode(file("user-data.sh"))
  vpc_security_group_ids = [aws_security_group.sg-1.id]

}

resource "aws_lb" "alb1" {
  internal = false
  security_groups = [aws_security_group.sg-1.id]
  subnets = aws_subnet.public-subnets[*].id
  tags = {
    Name = "seif-elb-1"
  }
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "alb-target" {
  name = "seif-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.APP-VPC.id
}

resource "aws_autoscaling_attachment" "asg-attach" {  
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn = aws_lb_target_group.alb-target.arn
  
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb1.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target.arn
  }
}

