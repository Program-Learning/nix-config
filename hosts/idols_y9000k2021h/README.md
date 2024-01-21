# Host - y9000k2021h

Related:

- [/nixos-installer/README.shoukei.md](/nixos-installer/README.ai.md)

## Info

disk status & mountpoints:

```bash
› df -Th
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  790M     0  790M   0% /dev
tmpfs          tmpfs     7.8G   83M  7.7G   2% /dev/shm
tmpfs          tmpfs     3.9G  7.3M  3.9G   1% /run
tmpfs          tmpfs     7.8G  1.8M  7.8G   1% /run/wrappers
/dev/nvme0n1p2 ext4      921G  811G   64G  93% /
tmpfs          tmpfs     4.0M     0  4.0M   0% /sys/fs/cgroup
/dev/nvme0n1p1 vfat      511M   43M  469M   9% /boot/efi
tmpfs          tmpfs     1.6G  6.4M  1.6G   1% /run/user/1000
tmpfs          tmpfs     100K     0  100K   0% /var/lib/lxd/shmounts
tmpfs          tmpfs     100K     0  100K   0% /var/lib/lxd/devlxd
/dev/loop0     btrfs      30G  1.3G   29G   5% /var/lib/lxd/storage-pools/default

› lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0    30G  0 loop /var/lib/lxd/storage-pools/default
nvme0n1     259:0    0 953.9G  0 disk 
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0 936.4G  0 part /nix/store
│                                     /
└─nvme0n1p3 259:3    0    17G  0 part [SWAP]
```
