FROM centos:centos6
MAINTAINER Dave Johnston email: dave.johnston@icloud.com
WORKDIR /tmp

ENV FOREOPTS --enable-foreman-compute-ec2 \
 --enable-foreman-compute-libvirt \
 --enable-foreman-compute-vmware \
 --enable-foreman-compute-openstack \
 --enable-foreman-plugin-discovery \
 --enable-foreman-plugin-setup \
 --enable-foreman \
 --enable-puppet \
 --foreman-admin-password changeme 

RUN yum install -y \
 https://anorien.csc.warwick.ac.uk/mirrors/epel/6/x86_64/epel-release-6-8.noarch.rpm \
 http://yum.theforeman.org/releases/1.7/el6/x86_64/foreman-release.rpm \
 && wget https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework -O /usr/bin/pipework

RUN yum install -y scl-utils \
 rhscl-ruby193* \
 wget \
 tar \
 puppet \
 foreman-installer 

RUN puppet apply -e 'host { $::hostname: ensure => absent } -> host { "${::hostname}.docker.local": ip => $::ipaddress, host_aliases => [$::hostname] }' \
 && cp /etc/foreman/foreman-installer-answers.yaml /tmp \
 && foreman-installer $FOREOPTS \
 && wget http://downloads.theforeman.org/discovery/releases/2.0/fdi-image-2.0.0.tar \
 -O - | tar x --overwrite -C /var/lib/tftpboot/boot \
 && chmod a+x /usr/bin/pipework \
 && mv /tmp/foreman-installer-answers.yaml /etc/foreman/foreman-installer-answers.yaml \
 && echo `hostname -f` >> /tmp/old_proxy_name

ADD pxe_global_default /tmp/
ADD startup /usr/bin/startup
ADD reconfigure_foreman /usr/bin/reconfigure_foreman
RUN chmod a+x /usr/bin/startup /usr/bin/reconfigure_foreman

EXPOSE 8140 8443 53 53/udp 67/udp 68/udp 69/udp 80 443 3000 3306 5432 8140 8443 5910 5911 5912 5913 5914 5915 5916 5917 5918 5919 5920 5921 5922 5923 5924 5925 5926 5927 5928 5929 5930

ENTRYPOINT [ "/usr/bin/startup" ]
