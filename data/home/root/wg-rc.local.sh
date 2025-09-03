#!/bin/bash

echo "venus-wg: start"

echo "venus-wg: checking internet connection"
while ! ping -c1 1.1.1.1 > /dev/null 2>&1; do
        echo "venus-wg: could not ping 1.1.1.1, retry in 60s"
        sleep 60
done
echo "venus-wg: connection successful"

echo "venus-wg: checking wireguard-tools"

if [ ! -x "$(which wg)" ]; then
        echo "venus-wg: wg not found, installing"
        mount -o remount,rw /
        opkg update
        opkg install wireguard-tools
        mount -o remount,ro /
else
        echo "venus-wg: wg found"
fi

echo "venus-wg: bringing up tunnel"
/usr/bin/wg-quick up /data/etc/wireguard/wg0.conf

echo "venus-wg: adding wg-reresolve cronjob"
echo "* * * * * root /data/home/root/wg-reresolve-dns.sh /data/etc/wireguard/wg0.conf > /dev/null 2>&1" > /etc/cron.d/wg-reresolve-dns

echo "venus-wg: finished"
