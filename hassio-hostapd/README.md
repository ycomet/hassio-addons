# hassio-hostapd
Raspberry Pi as hotspot in hass.io

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

### This Hass.io Addon

This add-on allows you  to use the Raspberry Pi as a hotspot to connect the different devices directly to the `hass.io` network without going through the router.

## Installation

To use this repository with your own Hass.io installation please follow [the official instructions](https://www.home-assistant.io/hassio/installing_third_party_addons/) on the Home Assistant website with the following URL:

```txt
https://github.com/davidramosweb/hassio-addons
```

### Configuration

The available configuration options are as follows (this is filled in with some example data):

```
{
    "ssid": "WIFI_NAME",
    "wpa_passphrase": "WIFI_PASSWORD",
    "channel": "6",
    "address": "172.16.1.1",
    "netmask": "255.255.0.0",
    "broadcast": "172.16.255.255",
    "subnet": "172.16.0.0",
    "range_start": "172.16.1.2",
    "range_end": "172.16.254.254"
}
```
**Note**: _This is just an example, don't copy and paste it! Create your own!_

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/davidramosweb
