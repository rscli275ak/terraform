# Liste
variable "liste" {
  default = ["127.0.0.1 localhost","192.168.1.133 gitlab.test"]
}
resource "null_resource" "node1" {
 count = "${length(var.liste)}"
 triggers = {
   foo = element(var.liste, count.index)
 }
 provisioner "local-exec" {
  command = "echo '${element(var.liste, count.index)}' >> hosts.txt"
 }
}