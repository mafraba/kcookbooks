#
# Cookbook Name:: weave
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'docker::default'

node.default["weave"]["master_fqdn"] = node["fqdn"] if node["weave"]["ismaster"]

directory "/usr/local/bin/" do
	owner 'root'
	group 'root'
	mode '0755'
	recursive true
	action :create
end

remote_file "/usr/local/bin/weave" do
	mode '0755'
	source node["weave"]["binary_url"]
end

remote_file "/usr/local/bin/weave-helper" do
	mode '0755'
	source node["weave"]["binary_url"]
end

  #     WEAVE_PEERS="192.168.33.10"
  #     BRIDGE_ADDRESS_CIDR="10.9.1.1/24"
  #     BREAKOUT_ROUTE="10.9.0.0/16"

# Create bridge
execute "weave create-bridge"
execute "ip addr add dev weave #{node['weave']['host_cidr']}"
execute "ip route add #{node['weave']['cidr']} dev weave scope link"
execute "ip route add 224.0.0.0/4 dev weave"
# Update docker opts
# echo "DOCKER_OPTS=\"--insecure-registry='0.0.0.0/0' --bridge=weave -r=false\"" | sudo tee -a /etc/default/docker
# sudo service docker restart

docker_settings_file = Docker::Helpers.docker_settings_file(node)
docker_service = Docker::Helpers.docker_service(node)

docker_opts = Hash[Docker::Helpers.daemon_cli_args(node).split.map{|opt| opt.split('=',2)}]
docker_opts.merge!('--bridge' => 'weave', '--insecure-registry' => '0.0.0.0/0')
docker_opts_str = docker_opts.map{|opt, value| "#{opt}=#{value}" }.join(' ')

template docker_settings_file do
  source 'docker.sysconfig.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    'daemon_options' => docker_opts_str
  )
  cookbook "docker"
  # DEPRECATED: stop and start only necessary for 0.x cookbook upgrades
  # Default docker Upstart job now sources default file for DOCKER_OPTS
  # notifies :stop, "service[#{docker_service}]", :immediately
  # notifies :start, "service[#{docker_service}]", :immediately
  action :nothing
end

ruby_block "update_docker_config" do
  block do
    node.set['docker']['insecure-registry'] = '0.0.0.0/0'
		node.set['docker']['bridge'] = 'weave'
  end
  notifies :create, "template[#{docker_settings_file}]", :immediately
end


docker_image "zettio/weave" do 
	action :pull
end

docker_image "zettio/weavetools" do
	action :pull
end

docker_image "zettio/weavedns" do                                                                                                             
  action :pull
end

if node["weave"]["ismaster"]
	execute "weave launch -password #{node['weave']['password']}"
else
  execute "weave launch -password #{node['weave']['password']} #{node['weave']['master_fqdn']}"
end

execute "weave-helper"
