# foreman-docker
Foreman pre-installed in a docker image.  This foreman includes a smart proxy with DHCP,TFTP and Puppet pre-configured.  The Discovery and compute plugins are enabled by default.

To run:
    docker run -it --name foreman --privileged=true -p 443:443 -p 8443:8443 -p 8140:8140 -p 67:67/udp -p 69:69/udp -p 80:80 davejohnston/foreman:1.7 --enable-dhcp --dhcp-range="10.30.0.100 10.30.0.200"
