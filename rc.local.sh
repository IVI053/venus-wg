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

if [ -L /etc/wireguard ]; then
        echo "venus-wg: /etc/wireguard is already a symlink; no change"
elif [ -d /etc/wireguard ]; then
        if [ -z "$( ls -A /etc/wireguard )" ]; then
                echo "venus-wg: /etc/wireguard empty; creating symlink to /data/etc/wireguard"
                mount -o remount,rw /
                rmdir /etc/wireguard
                ln -s /data/etc/wireguard /etc/wireguard
                mount -o remount,ro /
        else
                echo "venus-wg: /etc/wireguard not empty; no change"
        fi
else
        echo "venus-wg: creating /etc/wireguard symlink to /data/etc/wireguard"
        mount -o remount,rw /
        ln -s /data/etc/wireguard /etc/wireguard
        mount -o remount,ro /
fi

echo "venus-wg: bringing up tunnel"
/usr/bin/wg-quick up wg0

if [ ! -f /etc/cron.d/venus-wg ]; then
        echo "venus-wg: adding cronjob"
        mount -o remount,rw /
        echo "* * * * * root /data/opt/venus-wg/reresolve-dns.sh wg0 > /dev/null 2>&1" > /etc/cron.d/venus-wg
        mount -o remount,ro /
else
        echo "venus-wg: cronjob present"
fi

echo "venus-wg: startup finished"
