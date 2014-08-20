echo "Running FSW Install Script"
java -jar distros/jboss-dv-installer-6.0.0.GA-redhat-4.jar support/InstallationScript.xml
echo "Copy Teiid Security Files"
cp support/teiid* installed/dv/jboss-eap-6.1/standalone/configuration
echo "Start Server"
installed/dv/jboss-eap-6.1/bin/standalone.sh -c standalone.xml
