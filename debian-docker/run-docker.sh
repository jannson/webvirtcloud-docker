#!/bin/bash

docker run --restart=unless-stopped -d \
  --cgroupns=host \
	--cap-add SYS_ADMIN \
  --tmpfs /tmp \
	--network host \
	-v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run:/var2/run \
	-v /mnt:/mnt:rslave \
	-v /mnt/nvme0n1-4/test/1panel:/iStorePanel \
	-e TZ=Asia/Shanghai \
  --dns=172.17.0.1 \
  --dns=223.5.5.5 \
	--name iStorePanel linkease/istorepanel

#	--name istorePanel istorepanel:0.3
