# Use jbossdemocentral/developer as the base
FROM jbossdemocentral/developer

# Maintainer details
MAINTAINER Andrew Block <andy.block@gmail.com>

# Environment Variables 
ENV BRMS_HOME /opt/jboss/brms
ENV BRMS_VERSION_MAJOR 6
ENV BRMS_VERSION_MINOR 0
ENV BRMS_VERSION_MICRO 3

ENV DV_HOME /opt/jboss/dv
ENV DV_VERSION_MAJOR 6
ENV DV_VERSION_MINOR 0
ENV DV_VERSION_MICRO 0
ENV DV_RELEASE_CYCLE 4

# ADD Installation Files
COPY support/installation-brms support/installation-brms.variables support/installation-dv installs/jboss-brms-installer-$BRMS_VERSION_MAJOR.$BRMS_VERSION_MINOR.$BRMS_VERSION_MICRO.GA-redhat-1.jar installs/jboss-dv-installer-$DV_VERSION_MAJOR.$DV_VERSION_MINOR.$DV_VERSION_MICRO.GA-redhat-$DV_RELEASE_CYCLE.jar  /opt/jboss/

# Configure project prerequisites and run installer and cleanup installation components
RUN sed -i "s:<installpath>.*</installpath>:<installpath>$DV_HOME</installpath>:" /opt/jboss/installation-dv \
  && java -jar /opt/jboss/jboss-dv-installer-$DV_VERSION_MAJOR.$DV_VERSION_MINOR.$DV_VERSION_MICRO.GA-redhat-4.jar  /opt/jboss/installation-dv \
  && sed -i "s:<installpath>.*</installpath>:<installpath>$BRMS_HOME</installpath>:" /opt/jboss/installation-brms \
  && java -jar /opt/jboss/jboss-brms-installer-$BRMS_VERSION_MAJOR.$BRMS_VERSION_MINOR.$BRMS_VERSION_MICRO.GA-redhat-1.jar  /opt/jboss/installation-brms -variablefile /opt/jboss/installation-brms.variables \
  && mkdir -p $DV_HOME/jboss-eap-6.1/standalone/deployments/vdb \
  && rm -rf jboss-dv-installer-$DV_VERSION_MAJOR.$DV_VERSION_MINOR.$DV_VERSION_MICRO.GA-redhat-4.jar /opt/jboss/installation-dv $DV_HOME/jboss-eap-6.1/standalone/configuration/standalone_xml_history/ /opt/jboss/jboss-brms-installer-$BRMS_VERSION_MAJOR.$BRMS_VERSION_MINOR.$BRMS_VERSION_MICRO.GA-redhat-1.jar /opt/jboss/installation-brms /opt/jboss/installation-brms.variables $BRMS_HOME/jboss-eap-6.1/standalone/configuration/standalone_xml_history/

# Copy demo, support files and helper script
COPY support/bpm-suite-demo-niogit $BRMS_HOME/jboss-eap-6.1/bin/.niogit
COPY support/application-roles.properties support/standalone.xml $BRMS_HOME/jboss-eap-6.1/standalone/configuration/
COPY support/teiidfiles/data/ $DV_HOME/jboss-eap-6.1/standalone/data/
COPY support/teiidfiles/vdb/ $DV_HOME/jboss-eap-6.1/standalone/deployments/vdb/
COPY support/teiidfiles/teiid-security-roles.properties support/teiidfiles/teiid-security-users.properties support/teiidfiles/standalone.dv.xml $DV_HOME/jboss-eap-6.1/standalone/configuration/
COPY support/docker/start.sh /opt/jboss/

# Swtich back to root user to perform build and cleanup
USER root

# Adjust permissions and cleanup
RUN chown -R jboss:jboss $BRMS_HOME/jboss-eap-6.1/bin/.niogit $BRMS_HOME/jboss-eap-6.1/standalone/configuration/application-roles.properties $BRMS_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml $DV_HOME/jboss-eap-6.1/standalone/data/Customer.txt $DV_HOME/jboss-eap-6.1/standalone/data/CustomerHistory.xml $DV_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml $DV_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml $DV_HOME/jboss-eap-6.1/standalone/deployments/*.vdb* /opt/jboss/start.sh \
&& mv -f $DV_HOME/jboss-eap-6.1/standalone/configuration/standalone.dv.xml $DV_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml \
&& chmod +x /opt/jboss/start.sh

# Run as JBoss 
USER jboss

# Expose Ports
EXPOSE 9990 9999 8080 31000 10090 10099 8180

# Default Command
CMD ["/bin/bash"]

# Helper script
ENTRYPOINT ["/opt/jboss/start.sh"]
