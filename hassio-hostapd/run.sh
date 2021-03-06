#!/bin/bash

# SIGTERM-handler this funciton will be executed when the container receives the SIGTERM signal (when stopping)
term_handler(){
	echo "Stopping..."
	ifdown wlan0
	ip link set wlan0 down
	ip addr flush dev wlan0
	exit 0
}

# Setup signal handlers
trap 'term_handler' SIGTERM

echo "Starting..."

echo "Set nmcli managed no"
nmcli dev set wlan0 managed no

CONFIG_PATH=/data/options.json

SSID=$(jq --raw-output ".ssid" $CONFIG_PATH)
WPA_PASSPHRASE=$(jq --raw-output ".wpa_passphrase" $CONFIG_PATH)
CHANNEL=$(jq --raw-output ".channel" $CONFIG_PATH)
ADDRESS=$(jq --raw-output ".address" $CONFIG_PATH)
NETMASK=$(jq --raw-output ".netmask" $CONFIG_PATH)
BROADCAST=$(jq --raw-output ".broadcast" $CONFIG_PATH)
SUBNET=$(jq --raw-output ".subnet" $CONFIG_PATH)
RANGE_START=$(jq --raw-output ".range_start" $CONFIG_PATH)
RANGE_END=$(jq --raw-output ".range_end" $CONFIG_PATH)

# Enforces required env variables
required_vars=(SSID WPA_PASSPHRASE CHANNEL ADDRESS NETMASK BROADCAST)
for required_var in "${required_vars[@]}"; do
    if [[ -z ${!required_var} ]]; then
        error=1
        echo >&2 "Error: $required_var env variable not set."
    fi
done

if [[ -n $error ]]; then
    exit 1
fi

# Setup hostapd.conf
echo "Setup hostapd ..."
echo "ssid=$SSID"$'\n' >> /hostapd.conf
echo "wpa_passphrase=$WPA_PASSPHRASE"$'\n' >> /hostapd.conf
echo "channel=$CHANNEL"$'\n' >> /hostapd.conf

# Setup dhcpd.conf
echo "Setup dhcpd with details: SUBNET: $SUBNET, NETMASK=$NETMASK, RANGE_START=$RANGE_START, RANGE_END=$RANGE_END"
echo "subnet $SUBNET netmask $NETMASK {" >> /etc/dhcp/dhcpd.conf
echo "    option broadcast-address $BROADCAST ;" >> /etc/dhcp/dhcpd.conf
echo "    option subnet-mask $NETMASK ;" >> /etc/dhcp/dhcpd.conf
echo "    option time-offset 0 ;" >> /etc/dhcp/dhcpd.conf
echo "    range $RANGE_START $RANGE_END ;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf

touch /var/lib/dhcp/dhcpd.leases

echo "Starting dhcpd ..."
/usr/sbin/dhcpd -4 -f -d --no-pid -cf /etc/dhcp/dhcpd.conf &

# Setup interface
echo "Setup interface ..."

#ip link set wlan0 down
#ip addr flush dev wlan0
#ip addr add ${IP_ADDRESS}/24 dev wlan0
#ip link set wlan0 up

echo "address $ADDRESS"$'\n' >> /etc/network/interfaces
echo "netmask $NETMASK"$'\n' >> /etc/network/interfaces
echo "broadcast $BROADCAST"$'\n' >> /etc/network/interfaces

ifdown wlan0
ifup wlan0

echo "Starting HostAP daemon ..."
hostapd -d /hostapd.conf & wait ${!}
