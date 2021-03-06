Vagrant.configure(2) do |config|
    common = <<-SHELL
    sudo apt-get update -qq && apt-get install -y -qq wget unzip 2>&1 >/dev/null
    curl -fsSL https://get.docker.com -o get-docker.sh 2>&1 >/dev/null
    sudo sh get-docker.sh 2>&1 >/dev/null
    sudo usermod -aG docker vagrant
    sudo service docker start
    sudo echo "autocmd filetype yaml setlocal ai ts=2 sw=2 et" > /home/vagrant/.vimrc
    sudo echo "alias python=/usr/bin/python3" >> /home/vagrant/.bashrc
    sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    SHELL
  
    terraform_inst = <<-SHELL
    wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
    sudo unzip terraform_0.12.24_linux_amd64.zip  -d /usr/local/bin/
    sudo chmod 755 /usr/local/bin/terraform
    SHELL

    config.vm.define "terraform" do |control|
      control.vm.hostname = "terraform"
      control.vm.box = "ubuntu/bionic64"
      control.vm.box_url = "ubuntu/bionic64"
      control.vm.network "private_network", ip: "192.168.21.102"
      control.vm.provider "virtualbox" do |v|
          v.customize [ "modifyvm", :id, "--cpus", "1" ]
          v.customize [ "modifyvm", :id, "--memory", "1024" ]
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          v.customize ["modifyvm", :id, "--name", "terraform"]
      end
      control.vm.provision :shell, :inline => common
      control.vm.provision :shell, :inline => terraform_inst
      control.vm.synced_folder "share/", "/home/vagrant/share"
    end
  
    config.vm.define "target" do |control|
      control.vm.hostname = "target"
      control.vm.box = "ubuntu/bionic64"
      control.vm.box_url = "ubuntu/bionic64"
      control.vm.network "private_network", ip: "192.168.21.103"
      control.vm.provider "virtualbox" do |v|
          v.customize [ "modifyvm", :id, "--cpus", "1" ]
          v.customize [ "modifyvm", :id, "--memory", "1024" ]
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          v.customize ["modifyvm", :id, "--name", "target"]
      end
        #control.vm.provision :shell, :inline => common
    end
  end