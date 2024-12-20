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
ADD ./webvirtcloud /srv/webvirtcloud

#    && cat /app/gpt.txt | apt-key add - \
RUN apt-get update \
    && apt-get install -y locales \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common \
    && apt-get install -y wget tar unzip zip curl git gnupg sudo sqlite3 tzdata procps \
    && locale-gen en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable nightly"

RUN apt-get update && apt-get -y install git virtualenv python3-virtualenv python3-dev python3-lxml \
    libvirt-dev zlib1g-dev libxslt1-dev nginx supervisor libsasl2-modules gcc pkg-config python3-guestfs \
    libsasl2-dev libldap2-dev libssl-dev

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

COPY files/docker/systemctl3.py /usr/bin/systemctl
RUN test -e /bin/systemctl || ln -sf /usr/bin/systemctl /bin/systemctl

#COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update \
    && rm -f /etc/apt/apt.conf.d/proxy.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /srv/webvirtcloud/manual-install.sh
VOLUME /sys/fs/cgroup
VOLUME /var2/run
WORKDIR /

CMD ["/usr/bin/systemctl"]

