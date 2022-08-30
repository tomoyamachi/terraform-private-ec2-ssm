resource "aws_key_pair" "example" {
  key_name   = "${var.name}-keypair"
  public_key = file("./${var.key_name}.pub") # 先程`ssh-keygen`コマンドで作成した公開鍵を指定
}
