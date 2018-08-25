FROM java:8-alpine
ARG VERSION=4.27.0
ARG PUID=1000
ARG PGID=1000

LABEL name="GitBucket" version="$VERSION" maintainer="xyrusworx"

RUN addgroup -g $PGID gitbucket && \
    adduser -D -s /bin/false -u $PUID -h /var/lib/gitbucket -G gitbucket gitbucket

RUN mkdir -p /opt/gitbucket && \
	mkdir -p /var/run/gitbucket/tmp && \
	mkdir -p /var/lib/gitbucket && \
	chown --recursive gitbucket.gitbucket /opt/gitbucket && \
    chown --recursive gitbucket.gitbucket /var/lib/gitbucket && \
    chown --recursive gitbucket.gitbucket /var/run/gitbucket

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl && \
	wget -O /opt/gitbucket/gitbucket.war https://github.com/gitbucket/gitbucket/releases/download/$VERSION/gitbucket.war
	
VOLUME /var/lib/gitbucket
EXPOSE 8080

USER gitbucket
ENTRYPOINT ["java", "-jar", "/opt/gitbucket/gitbucket.war", "--gitbucket.home=/var/lib/gitbucket", "--temp_dir=/var/run/gitbucket/tmp"]