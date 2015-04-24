Vagrant.configure("2") do |config|
  config.vm.provision "chef_zero" do |chef|
    # Specify the local paths where Chef data is stored
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.nodes_path = "nodes"

    # Add a recipe
    chef.add_recipe "apache"

    # Or maybe a role
    chef.add_role "web"
  end
end