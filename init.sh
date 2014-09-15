#!/bin/sh 
DEMO="JBoss BRMS & JBoss DV Integration Demo"
AUTHORS="Kenny Peeples, Eric D. Schabell"
PROJECT="git@github.com:kpeeples/dv-brms-integration-demo.git"
PRODUCT="JBoss BRMS & JBoss DV Integration Demo"
JBOSS_HOME=./target/jboss-eap-6.1
JBOSS_HOME_DV=./target/jboss-eap-6.1.dv
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SERVER_BIN_DV=$JBOSS_HOME_DV/bin
SERVER_CONF_DV=$JBOSS_HOME_DV/standalone/configuration/
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
BRMS=jboss-brms-installer-6.0.2.GA-redhat-5.jar
DV=jboss-dv-installer-6.0.0.GA-redhat-4.jar
BRMS_VERSION=6.0.2
DV_VERSION=6.0.0

# wipe screen.
clear 

echo
echo "############################################################"
echo "##                                                        ##"   
echo "##  Setting up ${DEMO}     ##"
echo "##                                                        ##"   
echo "##                                                        ##"   
echo "##     ####   ####    #   #    ###       ####   #   #     ##"
echo "##     #   #  #   #  # # # #  #      #   #   #  #   #     ##"
echo "##     ####   ####   #  #  #   ##   ###  #   #  #   #     ##"
echo "##     #   #  #   #  #     #     #   #   #   #   # #      ##"
echo "##     ####   #   #  #     #  ###        ####     #       ##"
echo "##                                                        ##"   
echo "##                                                        ##"   
echo "##  brought to you by,                                    ##"   
echo "##             ${AUTHORS}            ##"
echo "##                                                        ##"   
echo "##  ${PROJECT}  ##"
echo "##                                                        ##"   
echo "############################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$BRMS ] || [ -L $SRC_DIR/$BRMS ]; then
	echo JBoss product sources, $BRMS present...
		echo
else
		echo Need to download $BRMS package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$DV ] || [ -L $SRC_DIR/$DV ]; then
	echo JBoss product sources, $DV present...
		echo
else
		echo Need to download $DV package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $JBOSS_HOME ]; then
		echo "  - existing JBoss product install detected and removed..."
		echo
		rm -rf ./target
fi

pause "start DV install"

# Run DV installer.
echo Product installer running now...
echo
java -jar $SRC_DIR/$DV $SUPPORT_DIR/installation-dv 
mv $JBOSS_HOME $JBOSS_HOME_DV

echo
echo "  - install teiid security files..."
echo
cp $SUPPORT_DIR/teiidfiles/teiid* $SERVER_CONF_DV

echo
echo "  - move data files..."
echo
cp -R $SUPPORT_DIR/teiidfiles/data $JBOSS_HOME_DV/teiidfiles/data

echo
echo "  - move virtual database..."
echo
cp -R $SUPPORT_DIR/teiidfiles/vdb $JBOSS_HOME_DV/standalone/deployments

echo "  - setting up dv standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/teiidfiles/standalone.dv.xml $SERVER_CONF_DV/standalone.xml

pause "start BRMS install"

# Run BRMS installer.
echo Product installer running now...
echo
java -jar $SRC_DIR/$BRMS $SUPPORT_DIR/installation-brms -variablefile $SUPPORT_DIR/installation-brms.variables

#echo "  - setting up demo projects..."
#echo
#cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF/standalone.xml

# Add execute permissions to the standalone.sh script.
echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

# Final instructions to user to start and run demo.
echo
echo "==========================================================================================="
echo "=                                                                                         =" 
echo "=  Start JBoss BPM Suite server:                                                          ="
echo "=                                                                                         =" 
echo "=    $ $SERVER_BIN/standalone.sh -Djboss.socket.binding.port-offset=100    ="
echo "=                                                                                         =" 
echo "=  In seperate terminal start JBoss DV server:                                            ="
echo "=                                                                                         =" 
echo "=    $ $SERVER_BIN_DV/standalone.sh                                        ="
echo "=                                                                                         =" 
echo "=                                                                                         =" 
echo "=  ******** APP LEVERAGES DV DATA SOURCES WITH BRMS RULES SCENARIO **********             ="
echo "=                                                                                         =" 
echo "=  Login to business central to build & deploy BRMS rules project at:                     ="
echo "=                                                                                         =" 
echo "=    http://localhost:8180/business-central     (u:erics/p:bpmsuite1!)                    ="
echo "=                                                                                         =" 
echo "=  As a developer you have an application project simulated as a unit test in             ="
echo "=  projects/brmsquickstart/helloworld-brms which you can run with the maven command:      ="
echo "=                                                                                         =" 
echo "=    $ mvn deploy -f projects/brmsquickstart/helloworld-brms/pom.xml                      ="
echo "=                                                                                         =" 
echo "=  View the DV setup:                                                                     ="
echo "=                                                                                         ="
echo "=         (TODO: Kenny sort this out)                                                     ="
echo "=                                                                                         ="
echo "=                                                                                         ="
echo "=   $DEMO Setup Complete.                                ="
echo "=                                                                                         ="
echo "==========================================================================================="
echo

