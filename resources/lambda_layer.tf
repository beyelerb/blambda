variable "layer_name" {}
{% if not skip-compatible-architectures %}
variable "compatible_architectures" {}
{% endif %}
variable "compatible_runtimes" {}
variable "filename" {}
{% if use-s3 %}
variable "s3_bucket" {}
variable "s3_key" {}
{% endif %}

resource "aws_lambda_layer_version" "layer" {
  layer_name = var.layer_name
  source_code_hash = filebase64sha256(var.filename)
{% if not skip-compatible-architectures %}
  compatible_architectures = var.compatible_architectures
{% endif %}
  compatible_runtimes = var.compatible_runtimes
{% if use-s3 %}
  s3_bucket = aws_s3_object.object.bucket
  s3_key = aws_s3_object.object.key
{% else %}
  filename = var.filename
{% endif %}
}

{% if use-s3 %}
resource "aws_s3_object" "object" {
  bucket = var.s3_bucket
  key = var.s3_key
  source = var.filename
  source_hash = filebase64sha256(var.filename)
}
{% endif %}

output "arn" {
  value = aws_lambda_layer_version.layer.arn
}
