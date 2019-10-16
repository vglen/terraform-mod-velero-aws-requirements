resource "aws_kms_key" "backups" {
  description             = "KMS key Used for k8s velero backups"
  deletion_window_in_days = 28

  tags = {
    Name        = "k8s-${var.product}-${var.cluster}"
    Environment = "${var.env}"
    Product     = "${var.product}"
  }
}

resource "aws_kms_alias" "backups" {
  name          = "alias/k8s-${var.product}-${var.cluster}"
  target_key_id = "${aws_kms_key.backups.key_id}"
}
