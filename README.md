JBoss BRMS & JBoss DV Integration Demo
======================================
This is a demo project to get you started with automatically installing two EAP instances, one with JBoss 
BRMS product and the other with JBoss DV product configured and installed.

There will be various example projects the demonstrate some of the available scenarios around working with 
the capabilities of these two product.

![Install](https://github.com/kpeeples/dv-brms-integration-demo/blob/master/docs/demo-images/dv+brms+image1.JPG?raw=true)


Quickstart
----------

1. [Download and unzip.](https://github.com/kpeeples/dv-brms-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat'.

Follow the instructions on the screen to start JBoss BRMS server and JBoss DV server.

   ```
   Start JBoss BRMS server:                                                       
                                                                                       
     $ ./target/jboss-eap-6.1/bin/standalone.sh -Djboss.socket.binding.port-offset=100 
                                                                                       
   In seperate terminal start JBoss DV server:                                         
                                                                                       
     $ ./target/jboss-eap-6.1.dv/bin/standalone.sh                                     
                                                                                       
   Login to business central to build & deploy BRMS rules project at:                     
                                                                                       
     http://localhost:8180/business-central     (u:quickstartUser/p:quickstartUser1!)                      
                                                                                       
     First Import the BRMS Repository  
     -Log in with the following credentials:  
         Username: quickstartUser  
         Password: quickstartPwd1!  
    -Choose menu option `Authoring` -> `Administration`  
    -Choose sub-menu option `Repositories` -> `Clone repository`  
    -Complete the form as follows:  
         Repository Name:      jboss-brms-repository  
         Organizational Unit:  example  
            either  
         Git URL:              file://path/to/jboss-brms-repository  
            or  
         Git URL:              https://github.com/jboss-developer/jboss-brms-repository.git  
         User Name:            <leave blank>  
         Password:             <leave blank>  
    -Click the `Clone` button to create the repository. You see the message "The repository is cloned successfully".        
    Second Deploy BRMS kmodule  
    -Choose menu option `Authoring` -> `Project Authoring`  
    -Choose the following options under `Project Explorer`:  
        Organizational Unit:  example  
        Repository Name:      jboss-brms-repository  
        BRMS Kmodule:         helloworld-brms-kmodule  
    -Next, click on `Tools` and `Project Editor`  
    -In the tab on the right, click on `Build & Deploy`.   
      * It will prompt you with a message: "Also save possible changes to project?". Click `Yes`.  
      * You are prompted for a comment. Add a comment and click on `Save` button.  
    -This deploys the `org.jboss.quickstarts.brms:helloworld-brms-kmodule:1.0.0` artifact to the BRMS Maven repository. You can verify the deployment choosing menu option `Deployment` --> `Artifact Repository`.  

   As a developer you have an application project simulated as a unit test in             
   projects/brmsquickstart/helloworld-brms which you can run with the maven command:      
                                                                                       
     $ mvn clean test -f projects/brmsquickstart/helloworld-brms/pom.xml -s quickstartsettings.xml -Penable-test,brms                        
                                                                                       
   View the Virtual Database Project:                                                                     
                                                                                       
       Import the DV project into JBDS with the Teiid tools installed.  
       See the How to guide for more detail.  
       The Virtual Database and data is installed during the init.sh script.                                                       

   Login to 
      DV JBoss Management: http://localhost:8080         (u:admin / p:redhat1!)  
      DV Dashboard: http://localhost:8080/dashboard	(u: user / p:user)  
      BRMS JBoss Management: http://localhost:8180         (u:erics / p:jbossbrms1!)  
      BRMS Business Central: http://localhost:8180/business-central	(u: erics / p:jbossbrms1!)  


   ```

Use Cases  
------------  
Use Case 1  
Objective-   
Deteremine what offers or discounts can be offered to the customer according to the customer context   
Problem-   
Call center agents don't have easy access to all the data and the business rules are manual   
Solution-   
Use Data Virtualization to create a unified view for a custoemr context which can then be applied to business rules in BRMS to automatically determine the offers or discounts for the customer   
Description:  
Data Driven Business Decisions Made easy.  
Customer 1 Tom BAD Smith with 450 Credit Score, Cold Sentiment, 2 calls. Customer 2 Bryan VIP Jacobs with 750 Credit score, Warm Sentiment, 7 calls. Customer 3 Michelle VIP Ramos with 650 credit score, hot sentiment, 2 calls. Customer 4 750 credit score, cold sentiment, 4 calls.
Rule BadCustomerSale when the customer type is bad then sale is denied. Rule RegularSale when the customer type is regular the sale is approved.  Rule VipDiscount when the customer type is VIP then the discount is .5 and sale is approved.

Coming soon:
------------
   
   * more demo ideas?


Supporting Articles
-------------------
How to guide for more detail on install to run the demo and to recreate from scratch in process with 3 videos - Part 1 Setup/Configuration, Part 2 Build/deploy, Part 3 Run.  
DV - Example of two federating two datasources - https://developer.jboss.org/docs/DOC-18404  
BRMS - A basic BRMS quickstart - http://www.jboss.org/quickstarts/brms/helloworld-brms/  

Released versions
-----------------

See the tagged releases for the following versions of the product:

- v1.1 - JBoss BRMS 6.0.2, JBoss DV 6.0.0, and initial demo projects installed.

- v1.0 - Kenny Peeples initial setup for webinar on this topic in July 2014.


![Install](https://github.com/kpeeples/dv-brms-integration-demo/blob/master/docs/demo-images/install-console.png?raw=true)

