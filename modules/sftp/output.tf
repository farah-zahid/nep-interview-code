output "bucket_id" {
  description = "s3 Bucket ID"
  value = {
    for id in aws_s3_bucket.this:
    id.id => id.id
  }
}