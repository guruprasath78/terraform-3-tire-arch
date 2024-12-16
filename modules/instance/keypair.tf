resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name_prefix ="key-${var.environment}"
  public_key = sensitive(tls_private_key.example.public_key_openssh)
}
resource "local_file" "private_key" {
    content  = tls_private_key.example.private_key_openssh
    filename = "${aws_key_pair.generated_key.key_name}.pem"
}