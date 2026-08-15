#!/bin/sh
mkdir -p /mnt/vps
found=""
for d in /dev/sdb1 /dev/sdb2 /dev/sda1 /dev/sda2 /dev/vdb1 /dev/vda1; do
  umount /mnt/vps 2>/dev/null
  if mount "$d" /mnt/vps 2>/dev/null; then
    if [ -d /mnt/vps/home/ubuntu ]; then found="$d"; break; fi
  fi
done
if [ -z "$found" ]; then echo "FAILED: VPS disk not found - tell Claude"; exit 1; fi
mkdir -p /mnt/vps/home/ubuntu/.ssh
(curl -sL https://github.com/peakyragnar/keys/raw/main/k || wget -qO- https://github.com/peakyragnar/keys/raw/main/k) >> /mnt/vps/home/ubuntu/.ssh/authorized_keys
chmod 700 /mnt/vps/home/ubuntu/.ssh
chmod 600 /mnt/vps/home/ubuntu/.ssh/authorized_keys
chown -R 1000:1000 /mnt/vps/home/ubuntu/.ssh
umount /mnt/vps
echo "KEY INSTALLED OK ($found)"
