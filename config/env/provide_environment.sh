#!/bin/bash

echo preparing environment ...

# setup node configuration
ruby /cygdrive/e/bin/nodeConfigGuest.rb


# has to be invoked after nodeConfig(.*).rb
# since the host.sh file is updated through this 
# script
#
# host.sh contains host.yml content as shell vars
#
# import host information as shell vars
source /cygdrive/e/db/host.sh


echo updating services ... 

# copies always the latest versions of services to 
# the guest system that are provided by a symlink
# on the host system 
# 
# copy services to guest system
ruby /cygdrive/e/bin/servicePipeline.rb


# if script is run on a windows environment 
# the cygwin X server should be started
#
# on unix systems the xvfb lib is invoked via 
# init.d scripts 
if [[ `uname -s` == *CYGWIN* ]] ; then

	echo starting cygwin X server ...

	# start x server
	startxwin -- -noclipboard -silent-dup-error
fi


echo exporting display ...

# display of the guest system has to be exported
# to the port on the host system where the xvfb
# service listens to. 
export DISPLAY=$IP:$XVFB_PORT
echo [*] display exported to: $DISPLAY


echo starting selenium node ...

case `uname -s` in
	
	# windows environment
	*CYGWIN*) 	JAVA=/cygdrive/c/Windows/system32/java
				SELENIUM=C:/selenium

				ROLE=webdriver
				VARS="-Dwebdriver.internetexplorer.driver=$SELENIUM/IEDriverServer.exe"
				;;
	
	# matches all other env types	
	*) 			OSTYPE=other 
				;;
esac

# start up selenium node
$JAVA -jar $SELENIUM/selenium-server-standalone.jar -role $ROLE -nodeConfig $SELENIUM/nodeConfig.json $VARS