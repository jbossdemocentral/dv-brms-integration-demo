@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=JBoss BRMS & JBoss DV Integration Demo
set AUTHORS=Andrew Block, Kenny Peeples
set PROJECT=git@github.com:kpeeples/dv-brms-integration-demo.git
set PRODUCT=JBoss BRMS & JBoss DV Integration Demo
set JBOSS_HOME=%PROJECT_HOME%target\jboss-eap-6.1
set JBOSS_HOME_DV=%PROJECT_HOME%target\jboss-eap-6.1.dv
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SERVER_BIN_DV=%JBOSS_HOME_DV%\bin
set SERVER_CONF_DV=%JBOSS_HOME_DV%\standalone\configuration\
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%support
set PRJ_DIR=%PROJECT_HOME%projects
set BRMS=jboss-brms-installer-6.0.3.GA-redhat-1.jar
set DV=jboss-dv-installer-6.0.0.GA-redhat-4.jar
set BRMS_VERSION=6.0.3
set DV_VERSION=6.0.0

REM wipe screen.
cls 

echo.
echo ############################################################
echo ##                                                        ##   
echo ##  Setting up %DEMO%                                ##
echo ##                                                        ##   
echo ##                                                        ##   
echo ##     ####   ####    #   #    ###       ####   #   #     ##
echo ##     #   #  #   #  # # # #  #      #   #   #  #   #     ##
echo ##     ####   ####   #  #  #   ##   ###  #   #  #   #     ##
echo ##     #   #  #   #  #     #     #   #   #   #   # #      ##
echo ##     ####   #   #  #     #  ###        ####     #       ##
echo ##                                                        ##   
echo ##                                                        ##   
echo ##  brought to you by,                                    ##   
echo ##     %AUTHORS%      ##
echo ##                                                        ##   
echo ##  %PROJECT%  ##
echo ##                                                        ##   
echo ############################################################
echo.


call where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo Maven Not Installed. Setup Cannot Continue
	GOTO :EOF
)

REM # make some checks first before proceeding. 
if exist %SRC_DIR%\%BRMS% (
	echo JBoss product sources, %BRMS% present...
	echo.
) else (
	echo Need to download %BRMS% package from the Customer Support Portal and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

if exist %SRC_DIR%\%DV% (
	echo JBoss product sources, %DV% present...
	echo.
) else (
	echo Need to download %DV% package from the Customer Support Portal and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

REM Move the old JBoss instance, if it exists, to the OLD position.
if exist %JBOSS_HOME% (
	echo - existing JBoss product install detected and removed...
	echo.

	rmdir /s /q "%PROJECT_HOME%\target"
)

REM Run DV installer.
echo Product installer running now...
echo.
call java -jar %SRC_DIR%\%DV% %SUPPORT_DIR%\installation-dv 

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During DV Installation!
	echo.
	GOTO :EOF
)

move "%JBOSS_HOME%" "%JBOSS_HOME_DV%"

echo.
echo   - install teiid security files...
echo.
xcopy /Y /Q /S "%SUPPORT_DIR%\teiid*" "%SERVER_CONF_DV%"

echo.
echo   - move data files...
echo.
xcopy /Y /Q /S "%SUPPORT_DIR%\teiidfiles\data\*" "%JBOSS_HOME_DV%\standalone\data"

echo.
echo   - move virtual database...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\teiidfiles\vdb" "%JBOSS_HOME_DV%\standalone\deployments"

echo   - setting up dv standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\teiidfiles\standalone.dv.xml" "%SERVER_CONF_DV%\standalone.xml"

REM Run BRMS installer.
echo Product installer running now...
echo.
call java -jar %SRC_DIR%\%BRMS% %SUPPORT_DIR%\installation-brms -variablefile %SUPPORT_DIR%\installation-brms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During BRMS Installation!
	echo.
	GOTO :EOF
)

echo.
echo   - setting up demo projects...
echo.
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit\*" "%SERVER_BIN%\.niogit\"

echo.
echo   - setting up roles adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"

echo.
echo   - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"

REM Final instructions to user to start and run demo.
echo.
echo ==============================================================================
echo =                                                                            = 
echo =  Start JBoss BPM Suite server:                                             =
echo =                                                                            = 
echo =    %SERVER_BIN%\standalone.bat -Djboss.socket.binding.port-offset=100    =
echo =                                                                            = 
echo =  In seperate terminal start JBoss DV server:                               =
echo =                                                                            = 
echo =    %SERVER_BIN_DV%\standalone.bat                                          =
echo =                                                                            = 
echo =                                                                            = 
echo =  ******* APP LEVERAGES DV DATA SOURCES WITH BRMS RULES SCENARIO ********   =
echo =                                                                            = 
echo =  Login to business central to build ^& deploy BRMS rules project at:       =
echo =                                                                            = 
echo =    http://localhost:8180/business-central                                  =
echo =                    user: quickstartUser / password: quickstartPwd1!        =
echo =                                                                            = 
echo =  As a developer you have an application project simulated as a unit test   =
echo =  in projects/brmsquickstart/helloworld-brms which you can run with the     =
echo =  maven command:                                                            =
echo =                                                                            = 
echo =    mvn clean test -f projects/brmsquickstart/helloworld-brms/pom.xml       =
echo =                            -s quickstartsettings.xml -Penable-test,brms    =
echo =                                                                            = 
echo =  View the DV setup:                                                        =
echo =                                                                            =
echo =    Refer to the how to guide and videos for specific setup.                =
echo =                                                                            =
echo =                                                                            =
echo =   %DEMO% Setup Complete.                                              =
echo =                                                                            =
echo ==============================================================================
