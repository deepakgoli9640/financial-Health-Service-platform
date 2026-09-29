FROM quay.io/keycloak/keycloak:26.3 AS builder

USER root

RUN mkdir -p /opt/keycloak/providers

# Download the Cloud SQL PostgreSQL Socket Factory
ADD --chown=keycloak:keycloak \
    https://repo1.maven.org/maven2/com/google/cloud/sql/postgres-socket-factory/1.30.0/postgres-socket-factory-1.30.0.jar \
    /opt/keycloak/providers/postgres-socket-factory.jar

# Download the required Cloud SQL Core dependency
ADD --chown=keycloak:keycloak \
    https://repo1.maven.org/maven2/com/google/cloud/sql/cloud-sql-connector-core/1.30.0/cloud-sql-connector-core-1.30.0.jar \
    /opt/keycloak/providers/cloud-sql-connector-core.jar

USER keycloak

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.3

COPY --from=builder --chown=keycloak:keycloak \
    /opt/keycloak/ /opt/keycloak/

USER keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start"]