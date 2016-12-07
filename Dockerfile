FROM ubuntu:16.04

# enable utf-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8


RUN apt-get update
RUN apt-get install -y curl cups avahi-daemon avahi-utils sudo supervisor libpopt0
RUN apt-get clean

# Install cups filter for specific printer
RUN curl -o cnijfilter-mg6100series-3.40-1-deb.tar.gz "http://gdlp01.c-wss.com/gds/8/0100003018/01/cnijfilter-mg6100series-3.40-1-deb.tar.gz"
RUN tar zxvf cnijfilter-mg6100series-3.40-1-deb.tar.gz
RUN cd cnijfilter-mg6100series-3.40-1-deb && bash ./install.sh

# Install Air Print Configuration Generator for iOS
RUN curl -o /usr/local/bin/airprint-generate https://raw.githubusercontent.com/tjfontaine/airprint-generate/master/airprint-generate.py
RUN chmod a+x /usr/local/bin/airprint-generate

RUN sed -i 's/#enable-dbus=yes/enable-dbus=no/' /etc/avahi/avahi-daemon.conf

ADD supervisord.conf /etc/supervisord.conf

EXPOSE 631

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
