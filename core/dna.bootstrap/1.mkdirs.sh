
export GENSYS=$(pwd);

mkdir -pv /{bin,boot,etc/{opt,sysconfig,pki/anchors},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
 x86_64) ln -sv /usr/lib /usr/lib64
         ln -sv /lib /lib64
         ln -sv /usr/local/lib /usr/local/lib64 ;;
esac

install -vdm755 /usr/lib/pkgconfig

mkdir -v /var/{log,mail,spool}
mkdir -pv /run/lock
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

