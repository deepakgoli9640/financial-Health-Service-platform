FROM maven:3.9-eclipse-temurin-21 AS dependencies

WORKDIR /build

RUN cat > pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>cloudsql-dependencies</artifactId>
    <version>1.0</version>

    <dependencies>
        <dependency>
            <groupId>com.google.cloud.sql</groupId>
            <artifactId>postgres-socket-factory</artifactId>
            <version>1.30.0</version>
        </dependency>
    </dependencies>

</project>
EOF

RUN mvn dependency:copy-dependencies \
    -DoutputDirectory=/build/providers \
    -DincludeScope=runtime


FROM quay.io/keycloak/keycloak:26.3 AS builder

COPY --from=dependencies /build/providers/ /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build


FROM quay.io/keycloak/keycloak:26.3

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start"]