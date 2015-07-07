#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM centos:7
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Update the base image:
#------------------------------------------------------------------------------

RUN rpm --import http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    yum update -y && yum clean all

#------------------------------------------------------------------------------
# Install grafana:
#------------------------------------------------------------------------------

ADD rootfs/etc/yum.repos.d/grafana.repo /etc/yum.repos.d/grafana.repo

RUN rpm --import https://packagecloud.io/gpg.key && \
    rpm --import https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana && \
    yum install -y grafana && yum clean all

#------------------------------------------------------------------------------
# Populate root file system:
#------------------------------------------------------------------------------

ADD rootfs /

#------------------------------------------------------------------------------
# Expose ports and entrypoint:
#------------------------------------------------------------------------------

WORKDIR /usr/share/grafana

EXPOSE 3000

ENTRYPOINT ["/init", "/usr/sbin/grafana-server", "--config=/etc/grafana/grafana.ini", "cfg:default.paths.logs=/var/log/grafana", "cfg:default.paths.data=/var/lib/grafana", "LimitNOFILE=10000"]
