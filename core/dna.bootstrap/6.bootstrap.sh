#!/bin/bash

BST="[<*>]";

echo "$BST BootStrap Genuine Release";

# Build packages
PKG_BUILD_ORDER=$(grep -v ^# BUILD_ORDER);

SOURCEPOOL="/SourcePool";
PACKAGEPOOL="/var/cache/genetic/PackagePool";

for PKG in $PKG_BUILD_ORDER; do

	# Package Name & Version
	PKG_VERSION=$(echo $PKG | awk -F- '{print $NF}');
	PKG_NAME=$(echo $PKG | sed -e 's/-'$PKG_VERSION'//g');

if test ! -d "/var/cache/genetic/$PKG_NAME"; then
	echo "$BST Installing '$PKG_NAME ($PKG_VERSION)' sources";

	genetic -i /SourcePool/$PKG_NAME-$PKG_VERSION.src.gen || exit 1;

	cd /var/tmp/genetic/$PKG_NAME-$PKG_VERSION;

	echo "$BST Building '$PKG_NAME ($PKG_VERSION)' packages";

	if test -d "$PKG_NAME"; then
		if test ! -f "$PKG_NAME/PostRemv"; then
			echo '#!/bin/bash' > $PKG_NAME/PostRemv;
		fi;
	fi;

	if test -d "$PKG_NAME-headers"; then
        	if test ! -f "$PKG_NAME-headers/PostRemv"; then
                	echo '#!/bin/bash' > $PKG_NAME-headers/PostRemv;
        	fi;
	fi;

	if test -d "$PKG_NAME-static"; then
        	if test ! -f "$PKG_NAME-static/PostRemv"; then
                	echo '#!/bin/bash' > $PKG_NAME-static/PostRemv;
        	fi;
	fi;

        if test -d "$PKG_NAME"; then
		if test ! -f "$PKG_NAME/PreRemv"; then
			echo '#!/bin/bash' > $PKG_NAME/PreRemv;
        	fi;
	fi;

        if test -d "$PKG_NAME-headers"; then
        	if test ! -f "$PKG_NAME-headers/PreRemv"; then
                	echo '#!/bin/bash' > $PKG_NAME-headers/PreRemv;
        	fi;
	fi;

        if test -d "$PKG_NAME-static"; then
        	if test ! -f "$PKG_NAME-static/PreRemv"; then
                	echo '#!/bin/bash' > $PKG_NAME-static/PreRemv;
        	fi;
	fi;

	genetic --disable-gen-all -b SrcInfo || exit 1;

	echo "$BST Installing '$PKG_NAME ($PKG_VERSION)' packages";

	find $PACKAGEPOOL -iname "$PKG_NAME*-$PKG_VERSION*.gen" -exec genetic -i {} \;

	echo "Cleaning /var/tmp/genetic ...";
	rm -rf /var/tmp/genetic/*

	# Adjust toolchain after reinstalling glibc #
	if test "$PKG_NAME" == "glibc"; then
		echo "$BST Adjusting Glibc Toolchain";
		bash ./6.1.toolchain.sh

		#mv -v /tools/bin/{ld,ld-old}
		#mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
		#mv -v /tools/bin/{ld-new,ld}
		#ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

		#gcc -dumpspecs | sed -e 's@/tools@@g'                   \
		#    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
		#    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
		#    `dirname $(gcc --print-libgcc-file-name)`/specs

		#echo 'main(){}' > dummy.c
		#cc dummy.c -v -Wl,--verbose &> dummy.log
		#readelf -l a.out | grep ': /lib'

		#grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
		#grep -B1 '^ /usr/include' dummy.log
		#grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
		#grep "/lib.*/libc.so.6 " dummy.log
		#grep found dummy.log
		#rm -v dummy.c a.out dummy.log
	fi;
fi;
done

echo "$BST Finished bootstrapping Genuine Release";

