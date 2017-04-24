FROM openjdk:8

RUN \
    # Build cas
    git clone --depth 1 -b master https://github.com/apereo/cas-overlay-template /cas-overlay && \
    cd /cas-overlay && \
    sed -e "/<\/dependencies>/ s/.*/<dependency>\n<groupId>org.apereo.cas<\/groupId>\n<artifactId>cas-server-support-jdbc-drivers<\/artifactId>\n<version>\${cas.version}<\/version>\n<\/dependency>\n<\/dependencies>/" -i pom.xml && \
    sed -e "/<\/dependencies>/ s/.*/<dependency>\n<groupId>org.apereo.cas<\/groupId>\n<artifactId>cas-server-support-jdbc<\/artifactId>\n<version>\${cas.version}<\/version>\n<\/dependency>\n<\/dependencies>/" -i pom.xml && \
    sed -e "/<\/dependencies>/ s/.*/<dependency>\n<groupId>org.apereo.cas<\/groupId>\n<artifactId>cas-server-support-json-service-registry<\/artifactId>\n<version>\${cas.version}<\/version>\n<\/dependency>\n<\/dependencies>/" -i pom.xml && \
    ./mvnw clean package && \
    # Generate ssl keypair
    mkdir /etc/cas && \
    keytool -genkey -noprompt \
      -alias mydomain \
      -keyalg RSA \
      -keysize 2048 \
      -dname "CN=localhost, OU=foo, O=foo, L=foo, S=foo, C=JP" \
      -keystore /etc/cas/thekeystore \
      -storepass changeit \
      -keypass changeit
# Inject the config files
COPY config/* /cas-overlay/etc/cas/config/
COPY services/* /cas-overlay/etc/cas/config/services/
# Locate the config files
RUN cd /cas-overlay && \
    ./build.sh copy
# Start
CMD cd /cas-overlay/target && java -jar cas.war