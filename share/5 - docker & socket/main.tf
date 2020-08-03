variable "ssh_host" {}
variable "ssh_user" {}
variable "ssh_key" {}
resource "null_resource" "ssh_target" {
    connection {
        type = "ssh"
        user = var.ssh_user
        host = var.ssh_host
        private_key = file(var.ssh_key)
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -qq 2>&1 >/dev/null",
            "curl -fsSL https://get.docker.com -o get-docker.sh 2>&1 >/dev/null",
            "sudo chmod 755 get-docker.sh",
            "sudo ./get-docker.sh >/dev/null"
        ]
    }
    provisioner "file" {
        source = "startup-options.conf"
        destination = "/tmp/startup-options.conf"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /etc/systemd/system/docker.service.d/",
            "sudo cp -a /tmp/startup-options.conf /etc/systemd/system/docker.service.d/startup_options.conf",
            "sudo systemctl daemon-reload",
            "sudo systemctl restart docker",
            "sudo usermod -aG docker vagrant"
        ]
    }
}
