resource "aws_s3_bucket" "flugel_s3_bucket" {
  bucket_prefix = var.s3_bucket_name_prefix
  acl           = var.s3_acl
}

resource "aws_s3_bucket_object" "flugel_s3_bucket_object" {
  bucket  = aws_s3_bucket.flugel_s3_bucket.id
  key     = format(var.filename_format, count.index + 1)
  content = local.current_time
  count   = var.file_count
}

resource "aws_s3_bucket_policy" "flugel_s3_bucket_policy" {
  depends_on = [
    aws_instance.public,
    aws_instance.instance
  ]

  bucket = aws_s3_bucket.flugel_s3_bucket.id
  policy = templatefile("files/bucket_policy.json", {
    arn             = aws_s3_bucket.flugel_s3_bucket.arn,
    first_node_ip   = aws_instance.public.public_ip,
    ip_node_list    = aws_instance.instance.*
  })
}
