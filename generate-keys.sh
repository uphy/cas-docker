#!/bin/bash

KEYS_DIR=keys

apachekey="$KEYS_DIR/apache.key"
apachecsr="$KEYS_DIR/apache.csr"
apachecrt="$KEYS_DIR/apache.crt"
caskeystore="$KEYS_DIR/cas.jks"
cascsr="$KEYS_DIR/cas.csr"
cascrt="$KEYS_DIR/cas.crt"

if [ ! -d "$KEYS_DIR" ]; then
    mkdir "$KEYS_DIR"
else
    echo Clean up the keys directory $KEYS_DIR
    rm -f "$KEYS_DIR"/*
fi

generateCasKey(){
    echo ==== Generating java key store... ====
    keytool -genkey -noprompt \
        -alias mydomain \
        -keyalg RSA \
        -keysize 2048 \
        -dname "CN=localhost, OU=foo, O=foo, L=foo, S=foo, C=JP" \
        -keystore "$caskeystore" \
        -storepass changeit \
        -keypass changeit
    keytool -exportcert \
        -keystore "$caskeystore" \
        -alias mydomain \
        -file "$cascrt" \
        -storepass changeit
}

generateApacheKey(){
    echo ==== Generating ssl keys... ====
    openssl genrsa 2048 > "$apachekey"
    openssl req -new -key "$apachekey"  \
            -out "$apachecsr" \
            -subj "/C=JP/ST=foo/L=foo/O=foo/OU=foo/CN=localhost"
    openssl x509 -req -signkey "$apachekey" < "$apachecsr" > "$apachecrt"
    rm -f "$apachecsr"
}

generateCasKey
generateApacheKey
