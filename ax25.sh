#!/bin/bash


# APRS poort aanmaken naar TNC-PI, een paar, i2c bus
# serial bus
# chmod 666 /dev/ttyAMA0
# /usr/sbin/kissattach /dev/ttyAMA0 aprspi 192.168.2.2


# AX25ipd port
#/usr/bin/socat pty,raw,echo=0,link=/var/run/axip pty,raw,echo=0,link=/var/run/pixa &
/usr/bin/socat PTY,link=/var/run/axip PTY,link=/var/run/pixa &
sleep 5
#/usr/sbin/kissattach /var/run/axip axip 44.137.55.2 &

# APRS injector ports
# Maak  koppelingen voor aprs
/usr/bin/socat -d -d -ly PTY,link=/var/run/com10 PTY,link=/var/run/com11 &
sleep 5
#/usr/sbin/kissattach /var/run/com10 stream 44.137.55.2 &
#/usr/sbin/kissattach /var/run/com11 maerts 44.137.55.2 &


# Cleanup network data
#/usr/sbin/ifconfig ax0 netmask 255.255.255.240
#/usr/sbin/ifconfig ax1 netmask 255.255.255.240
#/usr/sbin/ifconfig ax2 netmask 255.255.255.240
#/usr/sbin/ifconfig ax3 netmask 255.255.255.240

# Uronode tcp daemon
#service xinetd start

# Mheard
/usr/sbin/mheardd &

# AX25ipd
/usr/sbin/ax25ipd &

# AX25 Super Deamon
/usr/sbin/ax25d &

# Routing
/usr/sbin/ax25rtd &

# Netrom deamon
/usr/sbin/netromd -i &

# Sliplink with kernel
/usr/bin/socat -d -d -ly PTY,link=/var/run/slip PTY,link=/var/run/pils &
sleep 3
slattach -s 38400 -p slip /var/run/slip &
sleep 1
ifconfig sl0 <host ip> netmask 255.255.255.255 pointopoint <xnet ip> mtu 236 up
sleep 1

# AMPR net network give host a ham IP
ifconfig eth0:1 <ham ip> netmask 255.255.255.240 up
# ip route add -net 44.137.55.0/28 via 44.137.55.1 dev sl0

# Startup XNet
cd /opt/xnet; screen -d -m ./xnet_arm7

# Startup XRPI (xrouter)
# cd /opt/xrpi; screen -d -m ./xrpi

# FBB niet met & moet als laatste ktief blijven om docker actief te houden
#/usr/sbin/fbb

