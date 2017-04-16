FROM debian:jessie

RUN export rsync_version=3.1.2 \
 && export DEBIAN_FRONTEND=noninteractive \
 \
 && apt-get -q -y update \
 && apt-get -q -y install build-essential \
                          wget \
 && apt-get -q -y install libpopt0 \
                          zlib1g \
 \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 \
 && wget https://www.samba.org/ftp/rsync/src/rsync-${rsync_version}.tar.gz \
 && tar xvf rsync-${rsync_version}.tar.gz \
 && rm rsync-${rsync_version}.tar.gz \
 && cd rsync-${rsync_version} \
 && ./configure --prefix=/ \
 && make \
 && make install \
 && cd - \
 && rm -rf rsync-${rsync_version} \
 && echo -e "log file = /dev/stdout\nuse chroot = yes" > /etc/rsyncd.conf

EXPOSE 873

CMD [ "/bin/rsync", "--no-detach", "--daemon", "--config", "/etc/rsyncd.conf" ]