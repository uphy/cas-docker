# インストール手順

/cas-overlay/build.sh

### keystore生成  

```bash
keytool -genkey -noprompt \
  -alias mydomain \
  -keyalg RSA
  -keysize 2048
  -dname "CN=localhost, OU=foo, O=foo, L=foo, S=foo, C=JP" \
  -keystore /etc/cas/thekeystore \
  -storepass password \
  -keypass password
```

### pom.xmlの更新  
以下のdependencyを追加
- jdbc-drivers  
- jdbc

### 静的認証の無効化

```/etc/cas/config/cas.properties  
cas.authn.accept.users=
```

### 最終的なcas.properties

```
cas.server.name: https://cas.example.org:8443
cas.server.prefix: https://cas.example.org:8443/cas

endpoints.enabled=true
management.contextPath=/status
cas.adminPagesSecurity.ip=127\.0\.0\.1

logging.config: file:/etc/cas/config/log4j2.xml
# cas.serviceRegistry.config.location: classpath:/services

cas.authn.accept.users=

cas.authn.jdbc.query[0].sql=SELECT password FROM cas_users WHERE username=?
cas.authn.jdbc.query[0].healthQuery=SELECT 1 FROM cas_users
cas.authn.jdbc.query[0].isolateInternalQueries=false
cas.authn.jdbc.query[0].url=jdbc:postgresql://postgres:5432/postgres
cas.authn.jdbc.query[0].failFast=true
cas.authn.jdbc.query[0].isolationLevelName=ISOLATION_READ_COMMITTED
cas.authn.jdbc.query[0].dialect=org.hibernate.dialect.PostgreSQLDialect
cas.authn.jdbc.query[0].leakThreshold=10
cas.authn.jdbc.query[0].propagationBehaviorName=PROPAGATION_REQUIRED
cas.authn.jdbc.query[0].batchSize=1
cas.authn.jdbc.query[0].user=postgres
cas.authn.jdbc.query[0].ddlAuto=create-drop
cas.authn.jdbc.query[0].maxAgeDays=180
cas.authn.jdbc.query[0].password=password
cas.authn.jdbc.query[0].autocommit=false
cas.authn.jdbc.query[0].driverClass=org.postgresql.Driver
cas.authn.jdbc.query[0].idleTimeout=5000
cas.authn.jdbc.query[0].credentialCriteria=
cas.jdbc.showSql=true
cas.jdbc.genDdl=true
spring.jpa.show-sql=true

cas.authn.jdbc.query[0].passwordEncoder.type=NONE
```

### postgresqlメモ

docker-compose exec postgres psql -U postgres -h postgres
DELETE FROM cas_users;
INSERT INTO cas_users (username, password) VALUES ('guest', 'guest');


<dependency>\n<groupId>org.apereo.cas<\/groupId>\n<artifactId>cas-server-support-jdbc<\/artifactId>\n<version>${cas.version}<\/version>\n<\/dependency>