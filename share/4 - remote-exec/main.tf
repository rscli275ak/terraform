variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
resource "null_resource" "ssh_target" {
    connection {
        type = "ssh"
        user = var.ssh_user
        host = var.ssh_host
        private_key = file (var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -qq 2>&1 >/dev/null",
            "sudo apt-get install -qq -y nginx 2>&1 >/dev/null"
        ]
    }
    provisioner "file" {
        source = "nginx.conf"
        destination = "/tmp/default"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo cp -a /tmp/default /etc/nginx/sites-available/default",
            "sudo systemctl restart nginx"
        ]
    }
    provisioner "local-exec" {
        command = "curl ${var.ssh_host}:6666"
    }
}
