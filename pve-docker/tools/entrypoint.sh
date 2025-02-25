#!/bin/bash

vmease_startup() {
  vnet1=$1
  vnet2=$2
  curl -H "Content-Type: application/json" -X POST \
    -d '{"dockerName":"pve","vnet1":"'$vnet1'","vnet2":"'$vnet2'"}' \
    --fail --max-time 15 --unix-socket /host/var/run/vmease/daemon.sock \
    "http://localhost/api/vmease/startup/vm/"
}

if [ "$ISTOREOS" = "1" ]; then
  while true; do 
    if [ -S "/host/var/run/vmease/daemon.sock" ]; then
      echo "found daemon"
      break
    else
      echo "waiting daemon"
      sleep 5
    fi 
  done

  vnet1=pve-ext
  vnet2=pve-int
  vmease_startup $vnet1 $vnet2
  while true; do
    if ip link show "$vnet2" > /dev/null 2>&1; then
      ip link add br-lan type bridge
      ip link set $vnet2 master br-lan
      ip link set br-lan up
      ip link set $vnet2 up
      break
    else
      vmease_startup $vnet1 $vnet2
      sleep 3
    fi
  done
fi

if [ ! -z "$root_password" ]; then
	printf 'define the password,do config password %s\n' "$root_password"
	echo "root:$root_password"|chpasswd
fi

if [ ! -z "$port" ]; then
	printf 'replace Proxmox port to %s\n' "$port"
	sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Firewall.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Cluster/Setup.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/APIServer/AnyEvent.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/API2/LXC.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/API2/Qemu.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/APIClient/LWP.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/CLI/pct.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/CLI/qm.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Service/pveproxy.pm
	#sed -i "s/host => \$host/host => '127.0.0.1'/g" /usr/share/perl5/PVE/Cluster/Setup.pm
	# need patch pve-cluster/src/pmxcfs/pmxcfs.c
fi

if [ ! "$ISTOREOS" = "1" ]; then
  for i in `ip -o link show | awk -F': ' '{print $2}' |awk -F '@' '{print $1}'| grep -w -v 'lo' | grep -v '^docker' | grep -v '^br-'`;
  do
    if grep -iq "${i}" /etc/network/interfaces; then echo "${i} is exists"; continue; fi
    if [[ ${i} == *"ovs"* ]]; then
        echo "ovs link detect ${i}"
        echo -e "\niface ${i} inet manual\n        ovs_type OVSBridge" >> /etc/network/interfaces
    fi
  done
fi

#else
#  if ! grep -iq "pve-int" /etc/network/interfaces; then
#    echo -e "\niface pve-int inet manual\n        bridge-ports none\n        bridge-stp off\n        bridge-fd 0" >> /etc/network/interfaces
#  fi
#fi

[ -d "/host/var/run/openvswitch" ] && ln -s /host/var/run/openvswitch /var/run/ && echo "ln openvswitch"

exec "$@"
