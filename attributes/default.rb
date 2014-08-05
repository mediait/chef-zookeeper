default['zookeeper']['root_dir'] = "/usr/share/zookeeper"
default['zookepper']['jar_path'] = "/usr/share/java/"
default['zookeeper']['config_dir'] = "/etc/zookeeper/conf"
default['zookeeper']['data_dir'] = "/var/lib/zookeeper"
default['zookeeper']['client_port'] = "2181"
default['zookeeper']['myid'] = nil
default['zookeeper']['electionAlg'] = 3

default['zookeeper']['server_list'] = []
default['zookeeper']['eip_list'] = []    # for the ec2_eip recipe - The indexes correlate to server_list

default['zookeeper']['version'] = "3.4.6"
default['zookeeper']['url'] = "http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz"
default['zookeeper']['checksum'] = "971c379ba65714fd25dc5fe8f14e9ad1"
