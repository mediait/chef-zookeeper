
include_recipe "zookeeper"

gem_package "aws-sdk"

directory "/opt/bin" do
  recursive true
  action :create
end

template "/opt/bin/assign_eip" do
  source "assign_eip.rb.erb"
  mode "0744"
  owner "root"
  group "root"
end

if node['platform'] == "ubuntu"
  template "/etc/init/assign_eip.conf" do
    source "assign_eip_upstart.erb"
    mode "0744"
    owner "root"
    group "root"
  end
  
  service "assign_eip" do
    provider Chef::Provider::Service::Upstart
    action :enable
  end
end