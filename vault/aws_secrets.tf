resource "vault_aws_secret_backend" "aws" {
  access_key                = "${var.aws_access_key_id}"
  secret_key                = "${var.aws_access_key_secret}"
  region                    = "${var.aws_region}"
  default_lease_ttl_seconds = 600
  max_lease_ttl_seconds     = 72000
}

data "template_file" "aws_write_iam" {
  template = "${file("${path.module}/templates/aws_write.json")}"
}

data "template_file" "aws_read_iam" {
  template = "${file("${path.module}/templates/aws_read.json")}"
}

data "template_file" "aws_write_policy" {
  template = "${file("${path.module}/templates/aws_write.hcl")}"
}

data "template_file" "aws_read_policy" {
  template = "${file("${path.module}/templates/aws_read.hcl")}"
}

resource "vault_aws_secret_backend_role" "aws_write" {
  backend = "${vault_aws_secret_backend.aws.path}"
  name    = "aws_write"

  policy = "${data.template_file.aws_write_iam.rendered}"
}

resource "vault_aws_secret_backend_role" "aws_readonly" {
  backend = "${vault_aws_secret_backend.aws.path}"
  name    = "aws_readonly"

  policy = "${data.template_file.aws_read_iam.rendered}"
}

resource "vault_policy" "aws_readonly" {
  name = "aws_readonly"

  policy = "${data.template_file.aws_read_policy.rendered}"
}

resource "vault_policy" "aws_write" {
  name = "aws_write"

  policy = "${data.template_file.aws_write_policy.rendered}"
}
