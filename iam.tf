resource "aws_iam_user" "velero" {
  name = "k8s-${var.product}-${var.cluster}"
  path = "/"

  tags = {
    Name        = "k8s-${var.product}-${var.cluster}"
    Environment = "${var.env}"
    Product     = "${var.product}"
  }
}

resource "aws_iam_user_policy" "velero_ro" {
  name = "k8s-${var.product}-${var.cluster}"
  user = "${aws_iam_user.velero.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.backups.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.backups.id}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:Decrypt"
            ],
            "Resource": [
               "${aws_kms_key.backups.arn}"
            ]
        }
    ]
}
EOF
}
