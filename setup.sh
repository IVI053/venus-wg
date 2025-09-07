#!/bin/bash

echo "Creating example wireguard config"
mkdir -p /data/etc/wireguard/

cat <<EOT > /data/etc/wireguard/wg0.conf.example
[Interface]
PrivateKey = <your_private_key>
Address = 192.168.100.2/32,fddd:1234:5678:90ab::2/128
MTU = 1412

[Peer]
PublicKey = <peer_public_key>
PresharedKey = <pre_shared_key>
Endpoint = <ip_or_fqdn_of_peer>:<peer_port>
AllowedIPs = 192.168.0.0/24
PersistentKeepalive = 25
EOT

if [ -d /data/opt/venus-wg ]; then
        echo "Adding execution bits"
        chmod -R +x /data/opt/venus-wg
else
        echo "/data/opt/venus-wg does not exist!"
        echo "Check your installation! Aborting"
        exit
fi

if [ -f /data/opt/venus-wg/rc.local.sh ]; then
        echo "Modifying rc.local"
        echo "/data/opt/venus-wg/rc.local.sh &" >> /data/rc.local
        chmod +x /data/rc.local
else
        echo "/data/opt/venus-wg/rc.local.sh does not exist!"
        echo "Check your installation! Aborting"
        exit
fi

echo "Setup finished."
echo "Please remeber to create your wg0.conf in /data/etc/wireguard"
