# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.define "kube-master" do |master|
    master.vm.box = "trusty64"
    master.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    master.vm.network "private_network", ip: "192.168.33.10"
    master.vm.hostname = "kube-master"
    master.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"

      # Add a recipe
      # chef.add_recipe "etcd"

      # Or maybe a role
      chef.add_role "kube-master"
    end
  end

  config.vm.define "kube-slave-01" do |slave|
    slave.vm.box = "trusty64"
    slave.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    slave.vm.network "private_network", ip: "192.168.33.11"
    slave.vm.hostname = "kube-slave-01"
    slave.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"

      # Or maybe a role
      chef.add_role "kube-minion"
    end
  end

  # config.vm.define "kube-slave-02" do |slave|
  #   slave.vm.box = "trusty64"
  #   slave.vm.network "private_network", ip: "192.168.33.12"
  #   slave.vm.hostname = "kube-slave-02"
  # end
end