ARG BUILD_FROM
FROM $BUILD_FROM

MAINTAINER Nuno Covas <nuno.covas@gmail.com>

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk update && apk add --no-cache bash jq iw hostapd networkmanager net-tools sudo isc-dhcp-server && rm -rf /var/cache/apk/*


COPY hostapd.conf /
COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY interfaces /etc/network/interfaces
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
