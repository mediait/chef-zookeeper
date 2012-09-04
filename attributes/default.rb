default['zookeeper']['root_dir'] = "/usr/share/zookeeper"
default['zookepper']['jar_path'] = "/usr/share/java/"
default['zookeeper']['config_dir'] = "/etc/zookeeper/conf"
default['zookeeper']['data_dir'] = "/var/lib/zookeeper"
default['zookeeper']['client_port'] = "2181"
default['zookeeper']['myid'] = nil
default['zookeeper']['electionAlg'] = 3

default['zookeeper']['server_list'] = []
default['zookeeper']['eip_list'] = []    # for the ec2_eip recipe - The indexes correlate to server_list

default['zookeeper']['version'] = nil
default['zookeeper']['url'] = nil
default['zookeeper']['checksum'] = nil
