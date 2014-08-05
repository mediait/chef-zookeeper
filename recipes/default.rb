#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2011, Francesco Salbaroli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "apt"
include_recipe "java"


app_root_dir = node['zookeeper']['root_dir']
data_dir = node['zookeeper']['data_dir']
config_dir = node['zookeeper']['config_dir']
client_port = node['zookeeper']['client_port']
myid = node['zookeeper']['myid']
servers = node['zookeeper']['server_list']
election_alg = node['zookeeper']['electionAlg']

if node['zookeeper']['url'].nil?
  
  if node['zookeeper']['version']
    package "zookeeperd", node['zookeeper']['version']
  else
    package "zookeeperd"
  end
    
else
  
  directory app_root_dir do
     owner "zookeeper"
     group "zookeeper"
     mode "0755"
     action :create
  end

  directory config_dir do
     owner "zookeeper"
     group "zookeeper"
     mode "0755"
     action :create
  end

  directory data_dir do
     owner "zookeeper"
     group "zookeeper"
     mode "0755"
     action :create
  end

  src_filepath  = "#{Chef::Config['file_cache_path']}/zookeeper-#{node['zookeeper']['version']}.tar.gz"
  remote_file src_filepath do 
    source node['zookeeper']['url']
    checksum node['zookeeper']['checksum']
    backup false
  end

  bash "untar zookeeper" do
    user "root"
    cwd "/tmp"
    code %(tar zxf #{src_filepath} -C #{::File.dirname(src_filepath)})
    # not_if { File.exists? ::File.dirname(src_filepath) }
  end

  bash "copy zookeeper root" do
    user "root"
    cwd "/tmp"
    code %(cp -r #{::File.dirname(src_filepath)}/#{::File.basename(src_filepath, '.tar.gz')}/* /usr/share/java/)
  end
  
  if node['platform'] == "ubuntu"
    template "/etc/init/zookeeper.conf" do
      source "zookeeper_upstart.erb"
      mode "0644"
      owner "root"
      group "root"
    end
  end
  
end

template_variables = {
   :zookeeper_servers           => servers,
   :zookeeper_data_dir          => data_dir,
   :zookeeper_client_port       => client_port,
   :zookeeper_election_alg      => election_alg
}

%w{ configuration.xsl log4j.properties zoo.cfg environment }.each do |templ|
   template "#{config_dir}/#{templ}" do
      source "#{templ}.erb"
      mode "0644"
      owner "root"
      group "root"
      variables(template_variables)
   end
end

template "#{config_dir}/myid" do
   source "myid.erb"
   mode "0644"
   owner "zookeeper"
   group "zookeeper"
   variables({:myid => myid})
end

if node['platform'] == "ubuntu"
  service "zookeeper" do
     provider Chef::Provider::Service::Upstart
     action :restart
     running true
     supports :status => true, :restart => true
  end
else
  bash "restart zookeeper" do
    user "root"
    cwd "#{app_root_dir}"
    code %(bin/zkServer.sh restart)
  end 
end
