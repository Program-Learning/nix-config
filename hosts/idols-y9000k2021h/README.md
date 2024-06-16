# Host - y9000k2021h

Related:

- [/nixos-installer/README.md](/nixos-installer/README.md)

## TODOs

1. Install DCGM-Exporter on `y9000k2021h` to monitor the GPU status.

## Info

disk status & mountpoints:

```bash
› df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  790M     0  790M   0% /dev
tmpfs          tmpfs     7.8G  178M  7.6G   3% /dev/shm
tmpfs          tmpfs     3.9G  7.7M  3.9G   1% /run
tmpfs          tmpfs     7.8G  1.9M  7.8G   1% /run/wrappers
/dev/nvme0n1p2 ext4      921G  771G  104G  89% /
tmpfs          tmpfs     4.0M     0  4.0M   0% /sys/fs/cgroup
efivarfs       efivarfs  184K  180K     0 100% /sys/firmware/efi/efivars
/dev/sda3      fuseblk   119G   65G   54G  55% /run/media/nixos/windows
/dev/nvme0n1p1 vfat      511M   74M  438M  15% /boot/efi
tmpfs          tmpfs     1.6G  144K  1.6G   1% /run/user/1000
tmpfs          tmpfs     100K     0  100K   0% /var/lib/lxd/shmounts
tmpfs          tmpfs     100K     0  100K   0% /var/lib/lxd/devlxd
/dev/loop0     btrfs      30G  5.8G   24G  20% /var/lib/lxd/storage-pools/default

› lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0    30G  0 loop /var/lib/lxd/storage-pools/default
sda           8:0    0 119.2G  0 disk
├─sda1        8:1    0   260M  0 part
├─sda2        8:2    0   128M  0 part
├─sda3        8:3    0 118.1G  0 part /run/media/nixos/windows
└─sda4        8:4    0   802M  0 part
zram0       253:0    0   7.7G  0 disk [SWAP]
nvme0n1     259:0    0 953.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0 936.4G  0 part /gnu/store
│                                     /nix/store
│                                     /
└─nvme0n1p3 259:3    0    17G  0 part [SWAP]
```
