output flugel_s3_bucket_name {
  value = aws_s3_bucket.flugel_s3_bucket.id
}

output flugel_s3_bucket_objects {
  value = aws_s3_bucket_object.flugel_s3_bucket_object.*.id
}

output flugel_s3_bucket_domain_name {
  value = aws_s3_bucket.flugel_s3_bucket.bucket_regional_domain_name
}

output alb-url {
  value = aws_lb.alb.dns_name
}

output private_ec2 {
  value = aws_instance.private.*.private_ip
}
