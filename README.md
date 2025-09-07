Victron added wireguard kernel drivers with Version 3.20 of Venus OS.
Wireguard-tools are also provided with opkg since then.
This makes connections with wireguard easier, but some configuration
is still needed to get everything up and running.

In this repo I want to provide a collection of stuff I did to get
everything going.

# Setup

1. Copy all files in this repo into `/data/opt/venus-wg` on your venus device. You have to create this directory e.g with `mkdir -p /data/opt/venus-wg`
2. Execute setup.sh e.g. with `bash /data/opt/venus-wg/setup.sh`
3. Put your wireguard config into `/data/etc/wireguard` as `wg0.conf`. There is also a example file for your reference
4. reboot

# What it does

The setup creates a wireguard-conf-dir in `/data/etc/wireguard` which is the target of a symlink from `/etc`. There you need to put a valid wiregard-conf-file named `wg0.conf`. Furthermore the setup adds a line to your `rc.local` to execute in the background. This process checks for a working internet connection by pinging 1.1.1.1 (a Cloudflare DNS server). If successful it installs wireguard-tools and brings your tunnel up. If the ping is not successful it trys again every 60 seconds until it reaches 1.1.1.1. Additionally a cronjob is installed that runs every minute to reresolve the hostname of your peer. This needed if your peer has a changing IP. If your peer has a static IP it could be omitted but as there are no downsides of this reresolve in that case it can be left unchanged for simplification. It only generates very little DNS-traffic.

If setup correctly everything is update-safe and reinstalls automatically after updating Venus OS. Tested with 3.65
