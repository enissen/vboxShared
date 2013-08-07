#!/usr/bin/ruby

require 'fileutils'

host_dir = '/cygdrive/e/selenium/'
guest_dir = '/cygdrive/c/selenium/' 

# detect environment
env = `uname -s`

# selenium-server
FileUtils.cp_r host_dir + 'selenium-server', guest_dir + 'selenium-server-standalone.jar', :remove_destination => true
puts "[*] updated selenium-server"

case 

	# windows
	when env.match('^.*CYGWIN.*$')
		FileUtils.cp_r host_dir + 'utils/driver/ie/IEDriverServer', guest_dir + 'IEDriverServer.exe', :remove_destination => true
		puts "[*] updated IEDriverServer"

		FileUtils.cp_r host_dir + 'utils/driver/chrome/chromedriver.exe', guest_dir + 'chromedriver.exe', :remove_destination => true
		puts "[*] updated chrome driver"

end