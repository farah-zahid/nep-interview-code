module "sftp" {
  source            = "./modules/sftp"
  s3_bucket_names   = local.s3_bucket
  sftp_bucket_name  = "nep-interview-user1-bucket"
  sftp_user         = "user1"
}
