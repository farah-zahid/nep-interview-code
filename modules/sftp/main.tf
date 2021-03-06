locals {
  bucket = {
    for i in var.s3_bucket_names :
    i.HomeDirectory => i...
  }
}

resource "aws_s3_bucket" "this" {
  for_each = local.bucket
  bucket = each.key
}

resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.sftp_role.arn

  tags = merge({
    Name       = var.name
    Automation = "Terraform"
    }, var.tags)
}

resource "aws_s3_bucket_object" "s3_folder" {
  depends_on   = [aws_s3_bucket.this]
  bucket       = var.sftp_bucket_name
  key          = "${var.sftp_user}/"
  content_type = "application/x-directory"
}

#create sftp user 
resource "aws_transfer_user" "ftp_user" {
  depends_on     = [aws_s3_bucket.this]
  server_id      = aws_transfer_server.sftp_server.id
  user_name      = var.sftp_user
  role           = aws_iam_role.sftp_role.arn
  home_directory = "/${var.sftp_bucket_name}/${var.sftp_user}"
}

#SSH key for user to manage sftp account
#Generate SSH key using PuttyGen
resource "aws_transfer_ssh_key" "ssh_key" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = aws_transfer_user.ftp_user.user_name
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApjf+e/na2t1iIX2mSSyR3ll5VrlpxHS8THx9PIOPnoNXC5y4ERS7tJ/n50RiS6y9QiGKl0dDQvCaIVL0Ydj3NSYENKKYZ694vwro0uCH8FgmUEaofqWT9gogCsdj1SRLVhHzLub7Yqt4iFcXlM3RvMTUl0bwjowe5yyiWWKJL3ycwC+USEDgL1vsyS7zm4RcyC/FIn6oKoc/Y5rfoR+WWBLnSU8L1605sE4X/Z2GGb4JQj4VlopmBXLW9CyST5eXb0U5FU6+nL30fZVpgFim0IpBj4hCYyTClxwztl1WW9jmiCRM2JPdbv5TazJC1wxPx6NJDqrVmmcxClpLy3q+oQ== rsa-key-20200405"
}