#!/usr/bin/ruby

require 'yaml'


# pathes
host_dir = '/cygdrive/e/'
host_db_dir = host_dir + 'db/'
host_config_dir = host_dir + 'config/nodes/'
guest_dir = '/cygdrive/c/selenium/' 


# read machine vbox id
guest_name = File.open(guest_dir + '.id', 'r') { |f| f.read }

# read host information
host = YAML::load(File.open(host_db_dir + 'host.yml'))

# read config shape file 
config = File.open(host_config_dir + 'configShape.json', 'r') { |f| f.read }

# read node capabilities 
caps = File.open(host_config_dir + guest_name + '.json', 'r') { |f| f.read } 


# detect environment
env = `uname -s`

# set host-ip as shell variable in a file to import it afterwards
File.open(host_db_dir + 'host.sh', 'r+') {|f| f.puts "IP=\"#{host["IP"]}\"\ XVFB_PORT=\"#{host["XVFB_PORT"]}\"" } 


# evaluate IP of guest system
ip = case 

		# windows
		when env.match('^.*CYGWIN.*$')
			`ipconfig  | grep 'IPv4-Adresse' | cut -d: -f2 | awk '{gsub("[a-zA-Z]\s",""); print $1}'`.split(/\n/).last
	
	 end

# get IP
#ip = `ifconfig  | grep 'inet ' | grep -v '127.0.0.1' | grep -v '10\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | cut -d: -f2 | awk '{gsub("[a-zA-Z]\s",""); print $1}'`


{	"NODE_CAPABILITIES" => caps.strip, 
	"HOST_IP" => ip.strip,
	"HUB_IP" => host["IP"],
	"HUB_PORT" => host["SELENIUM_PORT"].to_s 
	
}.each do |key, value| 
	config = config.gsub!(/#{key}/, "#{value}")
end

#wildcards.each do |key, value|
#	config = config.gsub!(/#{key}/, "#{value}")
#end

# replace placeholders with local settings
#config = shape.gsub(/NODE_CAPABILITIES/, caps.strip).gsub(/HOST_IP/, ip.strip).gsub(/HUB_IP/, '91.250.87.191')

# delete content of target file and enter config string
File.open(guest_dir + 'nodeConfig.json', 'r+') {|f| f.puts config } 


puts '[*] Local node configuration file has been generated.'