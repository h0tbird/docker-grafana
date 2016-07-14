#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM debian:jessie
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables: https://grafanarel.s3.amazonaws.com
#------------------------------------------------------------------------------

ENV GF_VERSION="3.1.0-1468321182" \
    GF_URL="https://grafanarel.s3.amazonaws.com/builds"

#------------------------------------------------------------------------------
# Install grafana:
#------------------------------------------------------------------------------

RUN apt-get update \
    && apt-get -y --no-install-recommends install libfontconfig curl ca-certificates \
    && apt-get clean \
    && curl ${GF_URL}/grafana_${GF_VERSION}_amd64.deb > /tmp/grafana.deb \
    && dpkg -i /tmp/grafana.deb \
    && rm /tmp/grafana.deb \
    && curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu \
    && chmod +x /usr/sbin/gosu \
    && apt-get remove -y curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

#------------------------------------------------------------------------------
# Expose ports, volumes and entrypoint:
#------------------------------------------------------------------------------

EXPOSE 80
ENTRYPOINT ["./init"]
