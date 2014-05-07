#!/bin/bash

GENUINE_ROOT="$1";

if [ ! -d "$GENUINE_ROOT/dev" ]; then
	mkdir -v $GENUINE_ROOT/dev
fi

if [ ! -d "$GENUINE_ROOT/proc" ]; then
        mkdir -v $GENUINE_ROOT/proc
fi

if [ ! -d "$GENUINE_ROOT/sys" ]; then
        mkdir -v $GENUINE_ROOT/sys
fi;

rm $GENUINE_ROOT/dev/console
rm $GENUINE_ROOT/dev/null

mknod -m 600 $GENUINE_ROOT/dev/console c 5 1
mknod -m 666 $GENUINE_ROOT/dev/null c 1 3

mount -v --bind /dev $GENUINE_ROOT/dev

mount -vt devpts devpts $GENUINE_ROOT/dev/pts
mount -vt tmpfs shm $GENUINE_ROOT/dev/shm
mount -vt proc proc $GENUINE_ROOT/proc
mount -vt sysfs sysfs $GENUINE_ROOT/sys
