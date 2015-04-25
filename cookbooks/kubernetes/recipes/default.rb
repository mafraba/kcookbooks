#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pkg_url = node['kube']['package']
pkg_name = ::File.basename(pkg_url)
download_dir = '/tmp'

# download kubernetes package
remote_file "#{download_dir}/#{pkg_name}" do
  source pkg_url
end

# extract kubernetes package
execute "extract package #{pkg_name}" do
  cwd download_dir
  command "tar xf #{pkg_name} && tar xf kubernetes/server/kubernetes-server-linux-amd64.tar.gz"
end

# create /opt/bin directory
directory '/opt/bin' do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

# copy kubernetes bin to /opt/bin dir
execute 'copy kubernetes to /opt/bin dir' do
  cwd download_dir
  command '/bin/cp -rf kubernetes/server/bin/kube* /opt/bin/'
end