data "aws_iam_user" "ci_user" {
  user_name = var.ci_username
}

resource "aws_s3_bucket" "backups" {
  bucket = "k8s-${var.product}-${var.cluster}"
  acl    = "private"
  region = var.region
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.backups.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backups" {
  bucket = "${aws_s3_bucket.backups.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "backups" {
  bucket = "${aws_s3_bucket.backups.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "velero-policy",
    "Statement": [
        {
            "Sid": "deny_all_but_velero",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.backups.arn}",
                "${aws_s3_bucket.backups.arn}/*"
            ],
            "Condition": {
                "StringNotLike": {
                    "aws:userId": [
                        "${aws_iam_user.velero.unique_id}",
                        "${data.aws_iam_user.ci_user.user_id}",
                        "arn:aws:iam::${var.account}:root"
                    ]
                }
            }
        },
        {
            "Sid": "allow_only_velero",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.backups.arn}",
                "${aws_s3_bucket.backups.arn}/*"
            ],
            "Condition": {
                "StringLike": {
                    "aws:userId": [
                        "${aws_iam_user.velero.unique_id}",
                        "${data.aws_iam_user.ci_user.user_id}",
                        "arn:aws:iam::${var.account}:root"
                    ]
                }
            }
        }
    ]
}
POLICY
}
