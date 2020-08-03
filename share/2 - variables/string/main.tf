# Variable
variable "string" {
  type = string
  default = "127.0.0.1 gitlab.test"
}
resource "null_resource" "node1" {
 provisioner "local-exec" {
  command = "echo '${var.string}' > hosts.txt"
 }
}

output "string" {
 value = var.string
}