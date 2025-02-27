# AX25
First experiment to create a docker container for native ax25 (incl fbb) 

This is not a stable release so be aware of bugs etc

Make a tree like this:
![Screenshot_20250108_201457](https://github.com/user-attachments/assets/185e16ee-3e2b-4c31-8d8d-5db3ec3dbe96)


And put the files in this repo at the right places.

# You have docker installed?

Go into the map where you did put the files in and make te container wiht:
__docker build -t ax25 .__
Be aware of the dot at the end of the build command.

Check if there are any build errors, if not bring up your container with:
docker-compose up -d
Your container should be running. Check __/usr/lib/docker/volumes__, you should see ax25-conf and 4 other maps starting with ax25_

If you go into ax25_donf/_data you wil see all your ax25 configuaration files, adapt them to your needs, wait with fbb!
Go to the ax25_startup/_data map and chec ax25.sh adapt this file to you needs, leave fbb behind \#

## Kernel Modules
I am loading the ax25 kernel modules: ax25, mkiss and netrom in rc.local. Additional kernel modules can be added to ax25.sh

## Openvpn
If you are in NL and want to use Hamnet as a single access point, obtain and openvpn configuration file from pe1chl. It contains all certificats and info that is neede to setup a link with Hamnet. Place this callsign.conf file in the ax25_openvpn/_data  container. That's all. Now restart your container by:
docker-compose down in the folder where the docker-compose.yml is. And start it with: docker-compose up -d

Now you should have a link to Hamnet and your ax25 stuff should be running.

## FBB
Now you want fbb to be running. Go into the container with:
docker exec -it ax25 bash
Life is good you are now in the shell of the container. Normal linux commands can be executed here (like top to see what is running).
type fbb and configuere it like usual (later you can adapt the configuaration files in ax25_conf/_data).
leave the container and go to ax25_opt/startup/_data/ax25.sh and remove the \# before the fbb startup command.

## Your all set, but it can be better
This Dockerfile is intended to use on 64bit arm systems (raspbian on rpi 4 or 5), to start 32 bit applications lik xnet, xrpi and bpq, I am installing the armhf architecture as well.
So you can add bpq, xnet, xrpi, use the maps in ax25_opt/_data for it. You can make more shell files in startup to start them (rc.local point to ths map and searches for name.sh. Or add them to your ax25.sh. For paths use /opt/xnet etc.
Check the ax25.sh file for startup for xnet and xrpi with screen. Later you can attach to the screen an work with the console if you want to.

# Bugs...
Probably there are. One is well known, if you put in a command like "docker restart x25", your ax25 stuff (kissattach) is not handling this very well. Instead use: "docker-compose down" and "docker-compose up -d"

Second: if you install docker from the raspberry-pi repos, you will have to use docker-compose. However if you have the docker repos enabled, use docker compose instead (and don't install docker-compose).

## What is the bug?
After testing the container for about a week and being stable, it was time to move it to a raspberry 5. However... starting xnet ended in a segmentation fault, same with xrpi. Checking the installed packages did not solve the problem. It turned out tha the pi 5 was behaving a bit strange. Tested with debian base image, starting xnet/xrpi was claiming a missching libc.so.6 (libm.so.6), bothe were in the system.
Gooing for the base image debian:bullsey solved the problem, however with bullsey the openvpn connection failed, stating wrong certificates. Finally using the ubuntu base image: ubuntu:20.04 solved both issues.

![Screenshot_20250126_105132](https://github.com/user-attachments/assets/b51d2378-294f-411d-979d-f79202aaaa6e)


## Base Image
As you can see I am using __ubuntu__ as a base image, some people like other base images, like __debian__. I have made the docker container with both of them. The debian version was twice in size (269 MB instead of the 137 MB of Ubuntu) but was still missing top, ps and some other commands. Also fbb was not properly starting. 
However, when adding features like dual architecture arm64 + armhf the size of the container is noww just under 1 GB. No further comparing with debian is done.

# Healthcheck
You can add a few lines to your docker compose file to check the health of your containers. If the container becomes unhealthe you can restart is with a command:
```
*/5 * * * * docker ps -q -f health=unhealthy | xargs docker restart
```
in the crontab. */5 is every 5 minutes a check, remove the /5 if you want a check every minute.
```yaml annotate
The docker-compose.yml
    healthcheck:
      # add this to crontabe -e to restart container is hamnet connection fails
      # * * * * * docker ps -q -f health=unhealthy | xargs docker restart
      test: "curl -f http://bla.ampr.org"
      interval: 1m30s
      timeout: 10s
      retries: 3
      start_period: 40s
      start_interval: 5s
```

When started with this addition under yur service docker will check if you can reach bla.ampr.org. This is for my connection with HamNet and the url must be available on HamNet only. You can change the test to your personal needs. 
If you start the container with this option, it states "starting" until the healthcheck is completed. When completed the status should change to: Healthy. You shoud not see "Running" anymore. However if the test results in a false, the container becomes "Unhealthy"  and the crontab command will testart the container.
When debugging, better not use the heathcheck.
