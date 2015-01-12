#!/toolbox/bin/bash

echo ""
echo " * [---] Bootstraping Genuine Base System...";
echo ""

# Install Genetic

cd /usr/Genetic/genetic
make install

cd /usr/Genetic/Bootstrap

# Install base system
SOURCEPOOL="/usr/Genetic/SourcePool";
PACKAGEPOOL="/usr/Genetic/PackagePool";
PACKAGES="man-pages \
glibc \
zlib \
binutils \
gmp \
mpfr \
mpc \
gcc \
sed \
pkg-config \
ncurses \
util-linux-ng \
e2fsprogs \
coreutils \
iana-etc \
m4 \
bison \
procps \
grep \
readline \
bash \
libtool \
gdbm \
inetutils \
perl \
autoconf \
automake \
bzip2 \
diffutils \
gawk \
file \
findutils \
flex \
gettext \
groff \
grub \
gzip \
iproute2 \
kbd \
less \
make \
man-db \
module-init-tools \
patch \
psmisc \
sysklogd \
sysvinit \
tar \
texinfo \
xz \
udev \
lvm2 \
openssl \
libgpg-error \
vim \
pth \
attr \
libxml2 \
Python \
cracklib \
shadow \
docbook-xml \
sgml-common \
tcl \
db \
expat \
freetype \
doxygen \
ruby \
docbook-xsl"

rm -rf /var/tmp/*

#Installl inux headers
if [ ! -d "/var/cache/gens/linux-headers" ]; then
	cd /var/tmp
	linux_headers=$(find $SOURCEPOOL -iname "linux*" -type f -exec ls {} \;);
	echo ""
	echo " * [---] Unpacking source $linux_headers ...";
	echo ""
	tar jxf $linux_headers -C .
	srcdir0=$(find . -iname "linux*" -type d);
	cd $srcdir0
	yes "2" | gen -b SrcInfo
	cd ..; rm -rf $srcdir0
	pkggen0=$(find $PACKAGEPOOL -iname "linux-headers*" -type f -exec ls -lrt {} \; | tail -1 | awk '{print $NF}');
	gen -i $pkggen0
else
	echo ""
	echo " * [---] Package linux-headers already installed."
fi;

for package in $PACKAGES; do
	if [ ! -d "/var/cache/gens/$package" ]; then
		cd /var/tmp
        	gensrc=$(find $SOURCEPOOL -iname "${package}*" -type f -exec ls {} \;);
		echo ""
		echo " * [---] Unpacking source $gensrc ...";
		echo ""
        	tar jxf $gensrc -C .
		srcdir=$(find . -iname "${package}*" -type d);
		cd $srcdir
		if [ ! -f "SrcInfo" ]; then
			echo " ! [ERR] SrcInfo file not found at: $PWD";
			exit 1;
		fi;
        	gen -b SrcInfo
		if [[ $? -ne 0 ]]; then
			exit 1;
		fi
		cd ..; rm -rf $srcdir;
        	pkggen=$(find $PACKAGEPOOL -iname "${package}*" -type f -exec ls -lrt {} \; | tail -1 | awk '{print $NF}');
        	gen -i $pkggen
	else
        	echo " * [---] Package $package already installed."
	fi;
done

echo ""

#Installl inux 
if [ ! -d "/var/cache/gens/linux" ]; then
	cd /var/tmp
	linux=$(find $SOURCEPOOL -iname "linux*" -type f -exec ls {} \;);
	echo ""
	echo " * [---] Unpacking source $linux ...";
	echo ""
	tar jxf $linux -C .
	srcdir2=$(find . -iname "linux*" -type d);
	cd $srcdir2
	yes "1" | gen -b SrcInfo
	cd ..; rm -rf $srcdir0
	pkggen2=$(find $PACKAGEPOOL -iname "linux*" -type f -exec ls -lrt {} \; | tail -1 | awk '{print $NF}');
	gen -i $pkggen2
else
	echo ""
	echo " * [---] Package linux already installed."
fi;

echo ""
echo " * [---] Build complete.";
echo ""

