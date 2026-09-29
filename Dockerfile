FROM quay.io/keycloak/keycloak:26.3

USER root

RUN mkdir -p /opt/keycloak/providers

RUN curl -L \
    -o /opt/keycloak/providers/postgres-socket-factory.jar \
    https://repo1.maven.org/maven2/com/google/cloud/sql/postgres-socket-factory/1.30.0/postgres-socket-factory-1.30.0.jar

RUN curl -L \
    -o /opt/keycloak/providers/cloud-sql-connector-core.jar \
    https://repo1.maven.org/maven2/com/google/cloud/sql/cloud-sql-connector-core/1.30.0/cloud-sql-connector-core-1.30.0.jar

RUN chown -R keycloak:keycloak /opt/keycloak/providers

USER keycloak

RUN /opt/keycloak/bin/kc.sh build

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start"]