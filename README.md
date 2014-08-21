JBoss BRMS & JBoss DV Integration Demo
======================================
This is a demo project to get you started with automatically installing two EAP instances, one with JBoss 
BRMS product and the other with JBoss DV product configured and installed.

There will be various example projects the demonstrate some of the available scenarios around working with 
the capabilities of these two product.


Quickstart
----------

1. [Download and unzip.](https://github.com/kpeeples/dv-brms-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat'.

Follow the instructions on the screen to start JBoss BRMS server and JBoss DV server.

   ```
   Start JBoss BPM Suite server:                                                       
                                                                                       
     $ ./target/jboss-eap-6.1/bin/standalone.sh -Djboss.socket.binding.port-offset=100 
                                                                                       
   In seperate terminal start JBoss DV server:                                         
                                                                                       
     $ ./target/jboss-eap-6.1.dv/bin/standalone.sh                                     
                                                                                       
   Login to business central to build & deploy BRMS rules project at:                     
                                                                                       
     http://localhost:8180/business-central     (u:erics/p:bpmsuite1!)                    
                                                                                       
   As a developer you have an application project simulated as a unit test in             
   projects/brmsquickstart/helloworld-brms which you can run with the maven command:      
                                                                                       
     $ mvn deploy -f projects/brmsquickstart/helloworld-brms/pom.xml                      
                                                                                       
   View the DV setup:                                                                     
                                                                                       
       (TODO: Kenny sort this out)                                                     

   Login to http://localhost:8080         (u:erics / p:jbossbrms1!)

   Note: JBoss DV user login (u:admin/p:jbossdv1!)

   ```


Coming soon:
------------
   
   * more demo ideas?


Supporting Articles
-------------------
None yet...


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.1 - JBoss BRMS 6.0.2, JBoss DV 6.0.0, and initial demo projects installed.

- v1.0 - Kenny Peeples initial setup for webinar on this topic in July 2014.


![Install](https://github.com/kpeeples/dv-brms-integration-demo/blob/master/docs/demo-images/install-console.png?raw=true)

