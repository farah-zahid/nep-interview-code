resource "aws_iam_role" "sftp_role" {
  name = "nep-interview-transfer-server-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

#Set SFTP user permissions.
resource "aws_iam_role_policy" "sftp_policy" {
  name = "nep-interview-transfer-server-iam-policy"
  role = aws_iam_role.sftp_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "*"
        },
        {
			    "Effect": "Allow",
          "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
         "Resource": [
            "arn:aws:s3:::${var.sftp_bucket_name}"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObjectVersion",
            "s3:GetObjectACL",
            "s3:PutObjectACL"
          ],
          "Resource": [
            "arn:aws:s3:::${var.sftp_bucket_name}/${var.sftp_user}/*"
        ]
      }
    ]
}
POLICY
}