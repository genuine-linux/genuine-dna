#!/toolbox/bin/bash

# Bootstrap Root Genuine GNU/Linux base system.

echo "Install is going to create base directories and files.";
echo "Be careful and use this is script just once.";
echo "Are you sure to continue?";
echo "";

# Setting toolbox directory
TOOLBOX="/toolbox";
GENS_DIR="/usr/Genetic";

echo "Create base directories";
mkdir -pv /{bin,boot,etc/opt,home,lib,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
echo "";

echo "Create /root and /tmp directories";
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
echo "";

echo "Create /usr and /usr/local directories";
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
echo "";

echo "Create /usr and /usr/local links.";
for dir in /usr /usr/local; do
	ln -sv share/{man,doc,info} $dir
done
echo "";

echo "Link architecture dependant directories.";
case $(uname -m) in
	x86_64) ln -sv lib /lib64 && ln -sv lib /usr/lib64 ;;
esac
echo "";

echo "Create var directories.";
mkdir -v /var/{lock,log,mail,run,spool}
mkdir -pv /var/{opt,cache,lib/{misc,locate},local}
echo "";

echo "Link toolbox tools to base system";
ln -sv $TOOLBOX/bin/{bash,cat,echo,pwd,stty,vi,vim} /bin
ln -sv $TOOLBOX/bin/perl /usr/bin
ln -sv $TOOLBOX/lib/libgcc_s.so{,.1} /usr/lib
ln -sv $TOOLBOX/lib/libstdc++.so{,.6} /usr/lib
ln -sv bash /bin/sh
ln -sv $TOOLBOX/bin/file /usr/bin
echo "";

# Create Mount Tab.
echo "Creating /etc/mtab";
touch /etc/mtab
echo "";

echo "Create initial /etc/passwd & /etc/group files.";
echo "root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false" >> /etc/passwd

echo "root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
mail:x:34:
nogroup:x:99:" >> /etc/group
echo "";

bash --login +h
