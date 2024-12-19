#!/bin/bash

docker run --restart=unless-stopped -d \
  --cgroupns=host \
	--cap-add SYS_ADMIN \
  --tmpfs /tmp \
	--network host \
  --privileged \
	-v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run:/var2/run \
  -v \"/mnt/nvme/dbconfig:/srv/webvirtcloud/dbconfig\" \
  -v /mnt:/mnt \
	-e TZ=Asia/Shanghai \
  --dns=172.17.0.1 \
  --dns=223.5.5.5 \
	--name webvirtcloud linkease/webvirttest:0.1

#	--name istorePanel istorepanel:0.3
