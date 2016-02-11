#!/bin/bash
# Starting services
/etc/init.d/dbus restart
service avahi-daemon start

# Starting homebridge
/home/app/homebridge/bin/homebridge
