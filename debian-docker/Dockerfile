FROM debian:bookworm

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai

RUN mkdir -p /srv
WORKDIR /srv
#COPY sources.list /etc/apt/sources.list
#COPY gpt.txt .
COPY files/docker/systemctl3.py /usr/bin/systemctl

#    && cat /app/gpt.txt | apt-key add - \
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get -y install virtualenv python3-virtualenv python3-lxml \
    nginx supervisor libsasl2-modules \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

RUN apt-get update && apt-get install -y libvirt-daemon libvirt-clients libvirt-daemon-system virtinst bridge-utils virt-manager \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf
COPY vmwebvirt.service /etc/systemd/system/vmwebvirt.service
COPY files/docker/systemctl3.py /usr/bin/systemctl
RUN rm -f /etc/apt/apt.conf.d/proxy.conf \
    && usermod -a -G libvirt www-data \
    && usermod -a -G libvirt root \
    && usermod -a -G kvm root \
    && usermod -a -G kvm www-data \
    && systemctl disable libvirtd \
    && test -e /bin/systemctl || ln -sf /usr/bin/systemctl /bin/systemctl

ADD ./webvirtcloud /srv/webvirtcloud
RUN /srv/webvirtcloud/manual-install.sh
VOLUME /sys/fs/cgroup
VOLUME /var2/run
WORKDIR /

CMD ["/usr/bin/systemctl"]

