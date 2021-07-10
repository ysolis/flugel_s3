resource "aws_security_group" "second_alb" {
    vpc_id = aws_vpc.second.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "second" {
    name = "second-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.second_alb.id]
    subnets = [
        aws_subnet.second[0].id,
        aws_subnet.second[1].id
    ]
}

resource "aws_lb_listener" "second" {
    load_balancer_arn = aws_lb.second.arn
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.second.arn
        type = "forward"
    }
}

resource "aws_lb_target_group" "second" {
    port = 8080
    protocol = "HTTP"
    vpc_id = aws_vpc.second.id
}
