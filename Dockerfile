FROM debian:jessie
#FROM resin/rpi-raspbian:jessie
MAINTAINER Bert Depaz <bert@depaz.be>

RUN apt-get update
RUN apt-get upgrade

##################################################
# Set environment variables                      #
##################################################

# Ensure UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

##################################################
# Install tools                                  #
##################################################

RUN apt-get install -y curl wget git apt-transport-https python build-essential make g++ libavahi-compat-libdnssd-dev libkrb5-dev vim net-tools npm ansible avahi-daemon avahi-utils
RUN alias ll='ls -alG'
RUN sed -i -e "s@#enable-dbus=no@enable-dbus=yes@" /etc/avahi/avahi-daemon.conf

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install --yes nodejs

##################################################
# Add app user                                   #
##################################################

RUN useradd --create-home --home-dir /home/app --shell /bin/bash app

#####SPECIFIC#####

##################################################
# Install homebridge                             #
##################################################

RUN chown -R app:app /home/app/
RUN chmod 744 /home/app/

USER app
RUN git clone https://github.com/nfarina/homebridge.git /home/app/homebridge

WORKDIR /home/app/homebridge
RUN git submodule init
RUN git submodule update

USER root
RUN npm install
RUN npm install -g homebridge-legacy-plugins

##################################################
# Start                                          #
##################################################

RUN mkdir -p /var/run/dbus
VOLUME /var/run/dbus

EXPOSE 5353 51826

CMD ["npm", "run", "start"]
RUN echo "/home/app/homebridge/bin/homebridge" > /root/run.sh
RUN chmod +x /root/run.sh

# as we are using "docker -v" to keep the config outside of the container, the config MUST NOT be in the container
RUN mkdir /root/.homebridge
COPY config.json /root/.homebridge/config.json

#
# TODO : Still a problem here: dbus and avahi-deamon have to be restarted manually.
#
RUN apt-get install --reinstall avahi-daemon
RUN /etc/init.d/dbus restart
RUN service avahi-daemon start

CMD ["/root/run.sh"]
