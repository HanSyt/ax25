# ax25
First experiment to create a docker container for native ax25 (incl fbb) 

This is not a stable release so be aware of bugs etc

Make a tree like this:
![Screenshot_20250108_182739](https://github.com/user-attachments/assets/c45af6ea-eaeb-4c70-98fa-9d2798d1cb74)

And put the files in this repo at the right places.

# You have docker installed?

Go into the map where you did put the files in and make te container wiht:
docker build -t ax25 .
Be aware of the dot at the end of the build command.

Check if there are any build errors, if not bring up your container with:
docker-compose up -d
Your container should be running. Check /usr/lib/docker/volumes, you should see ax25-conf and 4 other maps starting with ax25_

If you go into ax25_donf/_data you wil see all your ax25 configuaration files, adapt them to your needs, wait with fbb!
Go to the ax25_startup/_data map and chec ax25.sh adapt this file to you needs, leave fbb behind \#

# openvpn
If you are in NL and want to use hamnet as a single access point, obtain and openvpn configuration file from pe1chl. It contains all certificats and info that is neede to setup a link with Hamnet. Place this callsign.conf file in the ax25_openvpn/_data  container. That's all. Now restart your container by:
docker-compose down in the folder where the docker-compose.yml is. And start it with: docker-compose up -d

Now you should have a link to hanmnet and your ax25 stuff should be running.

# fbb
Now you want fbb to be running. Go into the container with:
docker exec -it ax25 bash
Life is good you are now in the shell of the container. Normal linux commands can be executed here (like top to see what is running).
type fbb and configuere it like usual (later you can adapt the configuaration files in ax25_conf/_data).
leave the container and go to ax25_opt/startup/_data/ax25.sh and remove the \# before the fbb startup command.

# your all set, but it can be better
However.. you can add bpq, xnet, xrpi as well, use the maps in ax25_opt/_data for it. You can make more shell files in startup to start them (rc.local point to ths map and searches for name.sh. Or add them to your ax25.sh. For paths use /opt/xnet etc.

# bugs...
Probably there are. One is well known, if you put in a command like "docker restart x25", your ax25 stuff (kissattach) is not handling this very well. Instead use: "docker-compose down" and "docker-compose up -d"

Second: if you install docker from the raspberry-pi repos, you will have to use docker-compose. However if you have the docker repos enabled, use docker compose instead (and don't install docker-compose).
