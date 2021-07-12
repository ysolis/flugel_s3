resource "aws_lb_target_group" "tg_alb" {
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.second.id
}

resource "aws_security_group" "sg_alb" {
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

resource "aws_lb" "alb" {
    name = "fugel-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg_alb.id]
    subnets = aws_subnet.public.*.id
}

resource "aws_lb_listener" "lst_alb" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.tg_alb.arn
        type = "forward"
    }
}


