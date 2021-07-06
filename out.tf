output flugel_s3_bucket_name {
  value = aws_s3_bucket.flugel_s3_bucket.id
}

output flugel_s3_bucket_objects {
  value = aws_s3_bucket_object.flugel_s3_bucket_object.*.id
}

output alb-url {
    value = aws_lb.second.dns_name
}
