ARG ALPINE_VERSION
ARG MAVEN_VERSION

FROM simaofsilva/openjdk11-alpine:${ALPINE_VERSION}

ARG MAVEN_VERSION
ENV MAVEN_HOME=/usr/lib/mvn
ENV PATH=${MAVEN_HOME}/bin:${PATH}

RUN apk add --no-cache --update ca-certificates && \
    apk add --no-cache --virtual .build-deps wget && \
    rm -rf /var/cache/apk/* && \
    find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
        -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit -noprompt \
        -file {} -alias {} \; && \
    keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts --storepass changeit

RUN wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    apk del .build-deps

CMD ["mvn"]
