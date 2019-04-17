# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/precise64"
  config.vm.hostname = "oracle"

  # share this project under /home/vagrant/vagrant-ubuntu-oracle-xe
  config.vm.synced_folder ".", "/home/vagrant/vagrant-ubuntu-oracle-xe", :mount_options => ["dmode=777","fmode=666"]

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521

  # VirtualBox configuration
  config.vm.provider :virtualbox do |vb|
    vb.name   = "oracle"
    vb.gui    = false
    vb.cpus   = 1    # Oracle 11G XE uses no more than 1 core
    vb.memory = 1024 # Oracle claims to need 512MB of memory available minimum
    vb.default_nic_type = "Am79C973" # Better virtual network hardware
	
    # Keeps time in sync even when Windows sleeps
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
	
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on" ] # Enables DNS behind NAT
    vb.customize ["modifyvm", :id, "--natdnsproxy1"       , "on" ] # Enables DNS behind NAT
    vb.customize ["modifyvm", :id, "--ioapic"             , "on" ] # Enables supporting for multiple cpus
    vb.customize ["modifyvm", :id, "--paravirtprovider"   , "kvm"] # Enables Paravirtualization (VirtualBox v5.x or later)
  end
  
  # Plugins configurations
  config.vbguest.auto_update = true # Enables automatic Guest Additions upgrade
#  config.proxy.enabled = true # Enables proxy configuration

  # Runs pre-install script
  config.vm.provision :shell, :path => "oracle-xe-preinstall.sh", :privileged => false

  # Runs installation script
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end

  # Runs post-install script
  config.vm.provision :shell, :path => "oracle-xe-postinstall.sh", :privileged => false
end
