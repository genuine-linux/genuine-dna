#!/bin/bash

GENUINE_ROOT="$1";

umount -v $GENUINE_ROOT/dev/shm
umount -v $GENUINE_ROOT/dev/pts
umount -v $GENUINE_ROOT/dev
umount -v $GENUINE_ROOT/proc
umount -v $GENUINE_ROOT/sys
