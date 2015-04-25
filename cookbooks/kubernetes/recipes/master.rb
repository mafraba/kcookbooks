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

# generate /etc/init files
%w(kube-apiserver.conf kube-controller-manager.conf kube-scheduler.conf).each do |file|
  cookbook_file "/etc/init/#{file}" do
    source "init_conf/#{file}"
    mode 00644
    action :create
  end
end

# generate /etc/init.d/ files
%w(kube-apiserver kube-controller-manager kube-scheduler).each do |file|
  cookbook_file "/etc/init.d/#{file}" do
    source "initd_scripts/#{file}"
    mode 00644
    action :create
  end
end

# generate kubernetes config file
%w(kube-apiserver kube-controller-manager kube-scheduler).each do |file|
  template "/etc/default/#{file}" do
    cookbook 'kubernetes'
    source "#{file}.erb"
    owner 'root'
    group 'root'
    mode 00644
    action :create
  end
end

# define kubernetes master services
%w(kube-apiserver kube-controller-manager kube-scheduler).each do |service|
  service service do
    action [:enable, :restart]
  end
end