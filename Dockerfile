FROM simaofsilva/openjdk11-alpine:11.0.25@sha256:8eac56876f73a39a94196fbfe8ecd4f0f17dec63b27bdb63195d99a2d8e32e6d

ARG MAVEN_VERSION
ENV MAVEN_HOME=/usr/lib/mvn
ENV PATH=${MAVEN_HOME}/bin:${PATH}

RUN set -eux && \
    apk add --no-cache --update ca-certificates && \
    apk add --no-cache --virtual .build-deps wget && \
    echo "Adding CA certificates\n" && \
    find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
        -cacerts -storepass changeit -noprompt -file {} -alias {} \; && \
    keytool -list -keystore ${JAVA_HOME}/jre/lib/security/cacerts --storepass changeit && \
    echo "Installing Maven\n" && \
    wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar zxf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    echo "Final cleanups\n" && \    
    rm -rf /var/cache/apk/* /tmp/* && \
    apk del .build-deps

CMD ["mvn"]
