# basic image for building ax25
FROM ubuntu

# some info
LABEL description="HAM Radio AX25 experiment"
LABEL version="0.1"
LABEL build="Hackberry Lane"
LABEL email="pe1fam@amsat.org"

# update from the external repo
RUN apt update

# some extra service needed in container
RUN apt install -y sudo kmod telnet xinetd

# install ax25 stuff
RUN apt install -y --install-recommends libax25 ax25-apps ax25-tools uronode fbb
RUN apt install -y --install-recommends socat aprsdigi aprx

# a user could come in handy
RUN useradd -m -s //bin/bash pi && usermod -a -G sudo pi && echo "pi:raspberry" | chpasswd

# this is where we want our config
VOLUME ["/etc/ax25","/opt/xnet","/var/ax25"]
EXPOSE 3600 3694 6300

# let's copy some needed files
ADD ./ax25 /etc/ax25
ADD ./var /var/ax25
ADD ./xnet /opt/xnet

# Uronode
ADD ./uronode /etc/xinetd.d
# services to add
RUN echo "uronode         3694/tcp                        # Node/URONode packet" >> /etc/services

# let's start off as user pi
WORKDIR /root
#USER pi

ENTRYPOINT exec /etc/ax25/rc.ax25a
#CMD ["-c"]
