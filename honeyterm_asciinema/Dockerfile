FROM ubuntu:18.04

WORKDIR /root/asciinema

# Install packages
RUN apt-get update \
  && apt-get -y install curl \
  && apt-get -y install wget \
  && apt-get -y install rsyslog

# Install openssh-server
RUN apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd

# Install python-setuptools
RUN apt-get -y install python3-setuptools

# Generates localisation files for asciinema
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc

#RUN sed -i 's/start on (filesystem and static-network-up) or failsafe-boot/start on filesystem/' /etc/init/rc-sysinit.conf
#RUN sed -i 's/start on runlevel \[2345\]/start on filesystem/g' /etc/init/ssh.conf

RUN cd /etc/rc3.d && ln -s ../init.d/ssh S99ssh
RUN cd /etc/rc3.d && ln -s ../init.d/rsyslog S99rsyslogd

# Install asciinema via modified package
ADD asciinema.tar /root
ADD honeypot.tar /root

RUN python3 /root/asciinema/setup.py install
RUN mkdir -m 0777 /var/log/honii

RUN /root/honeypot/setup.sh
RUN mkdir /lib/security/
RUN cp /root/honeypot/pwreveal.py /lib/security/
#RUN apt-get -y install less vim
EXPOSE 22/tcp
ENTRYPOINT ["/sbin/init"]
