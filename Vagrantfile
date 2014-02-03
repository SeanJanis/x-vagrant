# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Virtual boxes
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Forwarded ports
  config.vm.network :forwarded_port, guest: 1065, host: 1065  # web
  config.vm.network :forwarded_port, guest: 1066, host: 1066  # api
  config.vm.network :forwarded_port, guest: 1067, host: 1067  # auth

  # Use forward agent so you can use your keys from within vagrant
  config.ssh.forward_agent = true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "1.2.3.4"

  # Shared folder
  config.vm.synced_folder "../projects", "/home/vagrant/code", :nfs => true

  # Fine tune CPUs / Memory
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "4", "--ioapic", "on"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "vagrant/puppet/manifests"
    puppet.module_path    = "vagrant/puppet/modules"
    puppet.manifest_file  = "main.pp"
    puppet.options        = [
                              '--verbose',
                              #'--debug',
                            ]
  end
end
