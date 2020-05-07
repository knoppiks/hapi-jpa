FROM maven:3.6.3-jdk-8 as build

ARG HAPI_FHIR_STARTER_URL=https://github.com/hapifhir/hapi-fhir-jpaserver-starter/
ARG HAPI_FHIR_STARTER_BRANCH=v4.2.0

RUN git clone --depth=1 --branch ${HAPI_FHIR_STARTER_BRANCH} ${HAPI_FHIR_STARTER_URL} /tmp/hapi-fhir-jpaserver-starter/

WORKDIR /tmp/hapi-fhir-jpaserver-starter
RUN mvn package -DskipTests

FROM tomcat:9-jre11

RUN mkdir -p /data/hapi/lucenefiles && chmod 775 /data/hapi/lucenefiles
RUN rm -Rf /usr/local/tomcat/webapps/*
COPY --from=build /tmp/hapi-fhir-jpaserver-starter/target/hapi-fhir-jpaserver.war /usr/local/tomcat/webapps/ROOT.war

ENV HAPI_SERVER_ADDRESS="http://localhost:8080/fhir/"
