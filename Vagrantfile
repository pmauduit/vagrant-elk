# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.name = "elk"
    v.gui = true
  end

  config.vm.box = "debian/jessie64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.hostname = "elk.mydomain.org"

  # Setting up puppet
  config.vm.provision "shell", inline: "apt-get update || true"
  config.vm.provision "shell", inline: "apt-get install -y puppet hiera libaugeas0"
  config.vm.provision "shell", inline: "puppet cert generate $(facter fqdn) || true"


  # Puppet recipe
  config.vm.provision :puppet do |puppet|
    puppet.working_directory = "/tmp/vagrant-puppet"
    puppet.module_path       = "modules"
  end

end

