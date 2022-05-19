locals {
  s3_bucket = flatten([
    for users_details in var.users : {
      HomeDirectory = users_details.HomeDirectory
    }
  ])

  users     = flatten([
    for users_details in var.users : {
      sftp_user = users_details.Name
    }
  ])
}