FROM nginx:1.13.0

# Install libraries for building module and openssl command
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      git \
      libpcre3 \
      libpcre3-dev \
      libssl-dev \
      openssl \
      zlib1g-dev \
      && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Build and install cas-nginx_http_auth_module
RUN git clone https://github.com/detailyang/cas-nginx_http_auth_module && \
    curl -O http://nginx.org/download/nginx-1.13.0.tar.gz && \
    tar zxvf nginx-*.tar.gz && \
    rm -f nginx-*.tar.gz && \
    cd nginx-* && \
    ./configure  --with-compat  --add-dynamic-module=../cas-nginx_http_auth_module --modules-path=/usr/lib/nginx/modules && \
    make modules && \
    make install && \
    cd .. && \
    rm -rf cas-nginx_http_auth_module nginx-*

# Enable SSL
COPY ssl.conf /etc/nginx/conf.d
RUN mkdir -p /etc/nginx/ssl && \
    cd /etc/nginx/ssl && \
    openssl genrsa 2048 > server.key && \
    openssl req -new -key server.key  -out server.csr -subj "/C=JP/ST=foo/L=foo/O=foo/OU=foo/CN=localhost" && \
    openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt && \
    rm -f server.csr

# Create contents
RUN cd /usr/share/nginx/html/ && \
    mkdir public secured && \
    echo "This is nginx public content." >> public/index.html && \
    echo "This is nginx secure content." >> secured/index.html

COPY nginx.conf /etc/nginx/nginx.conf
