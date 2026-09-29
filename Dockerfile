FROM docker.io/keycloak/keycloak:latest

ADD --chown=keycloak:keycloak \
https://repo1.maven.org/maven2/com/google/cloud/sql/postgres-socket-factory/1.30.0/postgres-socket-factory-1.30.0.jar \
/opt/keycloak/providers/postgres-socket-factory.jar

RUN /opt/keycloak/bin/kc.sh build