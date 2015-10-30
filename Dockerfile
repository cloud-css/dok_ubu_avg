FROM cloudcss/debiani386:jessie
MAINTAINER Josef Fröhle "github@josef-froehle.de"

ENV DEBIAN_FRONTEND noninteractive

#Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Add Files
ADD /nodejs/ /var/www
ADD /run.sh /run.sh
RUN chmod 755 /run.sh

RUN apt-get update && apt-get update --fix-missing && \
    apt-get install -y curl supervisor python git openssl make build-essential gcc ca-certificates && \
    curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm install -g node-gyp && \
    npm update && \
    apt-get update --fix-missing && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/www && \
    curl -sL http://download.avgfree.com/filedir/inst/avg2013flx-r3118-a6926.i386.deb > /tmp/avg2013flx-r3118-a6926.i386.deb && \
    dpkg -i /tmp/avg2013flx-r3118-a6926.i386.deb && \
    /etc/init.d/avgd restart && avgupdate && \
    avgcfgctl -w UpdateVir.sched.Task.Disabled=false && \
    avgcfgctl -w Default.setup.daemonize=true && \
    avgcfgctl -w Default.setup.features.antispam=true && \ 
    avgcfgctl -w Default.setup.features.oad=false && \
    avgcfgctl -w Default.setup.features.scheduler=true && \
    avgcfgctl -w Default.setup.features.tcpd=false && \
    /etc/init.d/avgd stop && \
    apt-get autoremove -y && apt-get autoclean -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
VOLUME /data /var/www
WORKDIR /data

CMD ["/run.sh"]