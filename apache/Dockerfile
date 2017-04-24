FROM httpd:2.2.32

# Install required libraries
RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      build-essential \
      git \
      libcurl4-gnutls-dev \
      libpcre3-dev \
      libssl-dev \
      libtool && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Build mod_auth_cas
RUN cd /tmp && \
    git clone --depth 1 --branch v1.1 https://github.com/Jasig/mod_auth_cas && \
    cd mod_auth_cas && \
    sed -e "/CURLOPT_SSL_VERIFYPEER/ s/1L/FALSE/" -i src/mod_auth_cas.c && \
    sed -e "/CURLOPT_SSL_VERIFYHOST/ s/2L/FALSE/" -i src/mod_auth_cas.c && \
    autoreconf -ivf && \
    ./configure && make && make install && \
    cd /tmp && \
    rm -rf mod_auth_cas

ARG LOGIN_URL=https://localhost:8443/cas/login
ARG VALIDATE_URL=https://cas:8443/cas/serviceValidate
ARG SSL_SERVERNAME=localhost
# Setting up the mod_auth_cas
RUN mkdir -p /var/cache/apache2/mod_auth_cas/ && \
    chown daemon:daemon /var/cache/apache2/mod_auth_cas/ && \
    chmod 770 /var/cache/apache2/mod_auth_cas/ && \
    mkdir -p /usr/local/apache2/htdocs/secured && \
    echo "You are authorized." > index.html && \
    cd /usr/local/apache2/conf && \
    echo 'LoadModule auth_cas_module /usr/local/apache2/modules/mod_auth_cas.so' >> httpd.conf && \
    echo 'CASCookiePath /var/cache/apache2/mod_auth_cas/' >> httpd.conf && \
	echo "CASLoginURL $LOGIN_URL" >> httpd.conf && \
	echo "CASValidateURL $VALIDATE_URL" >> httpd.conf && \
    echo 'CASDebug On' >> httpd.conf && \
    echo '<Location /secured>' >> httpd.conf && \
	echo '	AuthType CAS' >> httpd.conf && \
	echo '	require valid-user' >> httpd.conf && \
	echo '</Location>' >> httpd.conf && \
    # Enable logging
    sed -e '/LogLevel/ s/warn/debug/' -i httpd.conf && \
    # Generate the certificates
    cd /usr/local/apache2/conf && \
    openssl genrsa 2048 > server.key && \
    openssl req -new -key server.key  -out server.csr -subj "/C=JP/ST=foo/L=foo/O=foo/OU=foo/CN=localhost" && \
    openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt && \
    sed -e "s/#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/" -i /usr/local/apache2/conf/httpd.conf && \
    sed -e "s/www\.example\.com/localhost/" -i /usr/local/apache2/conf/extra/httpd-ssl.conf && \
    sed -e "/ServerName/ s/localhost/$SSL_SERVERNAME/" -i /usr/local/apache2/conf/extra/httpd-ssl.conf
