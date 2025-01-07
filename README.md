# ax25
First experiment to create a docker container for native ax25 (incl fbb) 

This is not a stable release so be aware of bugs etc

Make a tree like this:

![Screenshot_20250107_190428](https://github.com/user-attachments/assets/ed76ce0d-edb1-4ec3-aea9-7534110c9e26)

put all your ax25 needed files in ax 25 (especially fbb), otherwise yu have to configure them from the container, same for var and xnet.

in ax25 I have an rc.ax25a startup file, this file is kind of important. There should always be a forground process, in my case fbb to keep te container running. However, the last line keeps te container running for debug reasons, if fbb crashes you might be able to debug.

Known issue:
Startup with docker-compose up -d & to start the container. A docker restart is currently not recrating kissattach files. Stopping is done with docker-compose down (and restart with up & again)


