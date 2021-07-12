output flugel_s3_bucket_name {
  value = aws_s3_bucket.flugel_s3_bucket.id
}

output flugel_s3_bucket_objects {
  value = aws_s3_bucket_object.flugel_s3_bucket_object.*.id
}

output flugel_s3_bucket_domain_name {
  value = aws_s3_bucket.flugel_s3_bucket.bucket_domain_name
}

output alb-url {
  value = aws_lb.alb.dns_name
}

output public_ec2 {
  value = aws_instance.public.public_ip
}

output public_dns_ec2 {
  value = aws_instance.public.public_dns
}
