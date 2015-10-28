FROM ubuntu:trusty
MAINTAINER Josef Fröhle "github@josef-froehle.de"

ENV DEBIAN_FRONTEND noninteractive
ENV buildDeps 'lib32z1 lib32ncurses5 lib32bz2-1.0'

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r cloudcss && useradd -r -g cloudcss cloudcss

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
        $buildDeps \
        supervisor \
	&& rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
#    && sed -i 's/exit 101/exit 0/' /usr/sbin/policy-rc.d \
    && curl -sSL "http://download.avg.com/filedir/inst/avg2013flx-r3118-a6926.i386.deb" -o avg2013flx.i386.deb \
	&& dpkg -i avg2013flx.i386.deb
#   && sed -i 's/exit 0/exit 101/' /usr/sbin/policy-rc.d \
#   && avgupdate

RUN mkdir /data && chown cloudcss:cloudcss /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 6379
CMD [ "avgupdate" ]