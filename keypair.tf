resource "aws_key_pair" "example" {
  key_name   = "example"
  public_key = file("./example.pub") # 先程`ssh-keygen`コマンドで作成した公開鍵を指定
}
