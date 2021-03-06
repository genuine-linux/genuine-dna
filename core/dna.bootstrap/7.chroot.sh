export GENSYS="$(pwd)";

if test ! -L "/dnatools"; then
  ln -sfv $GENSYS /dnatools
fi

mkdir -pv $GENSYS/{dev,proc,sys,run}

mknod -m 600 $GENSYS/dev/console c 5 1
mknod -m 666 $GENSYS/dev/null c 1 3

mount --bind /dev $GENSYS/dev/
mount -vt devpts devpts $GENSYS/dev/pts -o gid=5,mode=620
mount -vt proc proc $GENSYS/proc
mount -vt sysfs sysfs $GENSYS/sys
mount -vt tmpfs tmpfs $GENSYS/run

if [ ! -d "/run/lock" ]; then
	mkdir /run/lock
fi

if [ -h $GENSYS/dev/shm ]; then
  mkdir -pv $GENSYS/$(readlink $GENSYS/dev/shm)
  chmod 1777 $GENSYS/dev/shm
fi

cp /etc/resolv.conf $GENSYS/etc/resolv.conf

chroot "$GENSYS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login

umount dev/pts
umount run
umount sys
umount proc
umount dev

