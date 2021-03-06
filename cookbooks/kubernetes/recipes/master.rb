#

include_recipe 'kubernetes::default'

# define kubernetes master services
%w(kube-apiserver kube-controller-manager kube-scheduler).each do |file|

  cookbook_file "/etc/init/#{file}.conf" do
    source "init_conf/#{file}.conf"
    mode 00644
    action :create
  end

  cookbook_file "/etc/init.d/#{file}" do
    source "initd_scripts/#{file}"
    mode 00644
    action :create
  end

  template "/etc/default/#{file}" do
    cookbook 'kubernetes'
    source "#{file}.erb"
    owner 'root'
    group 'root'
    mode 00644
    action :create
  end

  service file do
    action [:enable, :restart]
  end
end