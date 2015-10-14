export LFS="$(pwd)";

if test ! -L "/dnatools"; then
  ln -sfv $LFS /dnatools
fi

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount --bind /dev $LFS/dev/
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

chroot "$LFS" /dnatools/bin/env -i \
	HOME=/root \
	TERM="$TERM" \
	PS1='\u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/dnatools/bin:/dnatools/sbin \
	/dnatools/bin/bash --login +h	

umount dev/pts
umount run
umount sys
umount proc
umount dev

