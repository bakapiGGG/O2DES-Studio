# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive


# Install necessary packages
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    tar \
    xmlstarlet \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Java and Tomcat
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH

# Install Tomcat (use the standard distribution, not fulldocs)
RUN mkdir -p "$CATALINA_HOME" \
    && cd $CATALINA_HOME \
    && wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.25/bin/apache-tomcat-10.1.25.tar.gz \ 
    && tar -xvf apache-tomcat-*.tar.gz --strip-components=1 \
    && ls -la /opt/tomcat/bin # Debugging: List contents to verify catalina.sh is present \
    && rm bin/*.bat || true \ 
    && rm apache-tomcat-*.tar.gz \
    && if [ ! -f "$CATALINA_HOME/bin/catalina.sh" ]; then echo "catalina.sh not found after extraction"; exit 1; fi

# Copy the WAR file from the build directory into the Tomcat webapps directory
COPY build/draw.war $CATALINA_HOME/webapps/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]

# # Use Ubuntu 22.04 as the base image
# FROM ubuntu:22.04

# # Avoid prompts from apt
# ENV DEBIAN_FRONTEND=noninteractive

# # Install necessary packages including Nginx
# RUN apt-get update && apt-get install -y \
#     openjdk-11-jdk \
#     wget \
#     tar \
#     xmlstarlet \
#     nginx \
#     && rm -rf /var/lib/apt/lists/*

# # Set environment variables for Java and Tomcat
# ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
# ENV CATALINA_HOME /opt/tomcat
# ENV PATH $CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH

# # Install Tomcat
# RUN mkdir -p "$CATALINA_HOME" \
#     && cd $CATALINA_HOME \
#     && wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.25/bin/apache-tomcat-10.1.25-fulldocs.tar.gz \
#     && tar -xvf apache-tomcat-*.tar.gz --strip-components=1 \
#     && rm apache-tomcat-*.tar.gz

# # Copy Nginx configuration
# COPY nginx.conf /etc/nginx/nginx.conf

# # Expose ports for Nginx (80) and Tomcat (8080)
# EXPOSE 80 8080

# # Custom script to start both Nginx and Tomcat
# COPY start.sh /start.sh
# RUN chmod +x /start.sh

# CMD ["/start.sh"]