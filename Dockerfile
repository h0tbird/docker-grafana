#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM alpine:3.4
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV GOPATH="/go" \
    VERSION="3.1.0"

#------------------------------------------------------------------------------
# Install grafana:
#------------------------------------------------------------------------------

RUN apk --no-cache add --update -t deps git go gcc musl-dev make g++ \
    && apk --no-cache add --update nodejs python \
    && go get -d github.com/grafana/grafana || true \
    && cd ${GOPATH}/src/github.com/grafana/grafana \
    && git checkout -b tags/v${VERSION} \
    && go run build.go setup \
    && ${GOPATH}/bin/godep restore \
    && go run build.go build \
    && npm install; npm install -g grunt-cli; grunt \
    && apk del --purge deps && rm -rf /tmp/* /var/cache/apk/*

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

#------------------------------------------------------------------------------
# Expose ports and entrypoint:
#------------------------------------------------------------------------------

EXPOSE 3000
WORKDIR "${GOPATH}/src/github.com/grafana/grafana"
ENTRYPOINT ["./bin/grafana-server"]
