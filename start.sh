#!/bin/bash
# Ensure CATALINA_HOME is set to the correct path where Tomcat is installed
CATALINA_HOME=/opt/tomcat

# Start Tomcat in the background using the full path
$CATALINA_HOME/bin/catalina.sh start

# Start Nginx in the foreground
nginx -g 'daemon off;'