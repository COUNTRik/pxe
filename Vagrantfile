# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "pxeserver" do |server|
    config.vm.box = 'centos/7'

    server.vm.host_name = 'pxeserver'
    server.vm.network :private_network, 
                       ip: "10.0.0.20", 
                       virtualbox__intnet: 'pxenet'

    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    server.vm.provision "shell",
      name: "Setup PXE server",
      path: "scripts/pxe.sh"
  end

  config.vm.define "pxeclient" do |pxeclient|
    
    pxeclient.vm.box = 'centos/7'
    pxeclient.vm.host_name = 'pxeclient'
    pxeclient.vm.network :private_network,
                          type: "dhcp",
                          virtualbox__intnet: 'pxenet'
    
    pxeclient.vm.provider :virtualbox do |vb|
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize [
          'modifyvm', :id,
          '--nic1', 'intnet',
          '--intnet1', 'pxenet',
          '--nic2', 'nat',
          '--boot1', 'net',
          '--boot2', 'none',
          '--boot3', 'none',
          '--boot4', 'none'
        ]
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  
  end

end