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

	cd /;

	genetic -i /SourcePool/$PKG_NAME-$PKG_VERSION.src.gen || exit 1;

	cd /var/tmp/genetic/$PKG_NAME-$PKG_VERSION;

	echo "$BST Building '$PKG_NAME ($PKG_VERSION)' packages";

	genetic --disable-gen-orig --disable-gen-debug -b SrcInfo || exit 1;

	echo "$BST Installing '$PKG_NAME ($PKG_VERSION)' packages";

	find $PACKAGEPOOL -iname "$PKG_NAME*-$PKG_VERSION*.x86_64.gen" -exec genetic -i {} \;
	find $PACKAGEPOOL -iname "$PKG_NAME*-$PKG_VERSION*.x86_64.dev.gen" -exec genetic -i {} \;
	find $PACKAGEPOOL -iname "$PKG_NAME*-$PKG_VERSION*.x86_64.doc.gen" -exec genetic -i {} \;

	echo "Cleaning /var/tmp/genetic ...";
	cd /; rm -rf /var/tmp/genetic/*

	# Adjust toolchain after reinstalling glibc #
	if test "$PKG_NAME" == "glibc"; then
		echo "$BST Adjusting Glibc Toolchain";
		bash ./6.1.toolchain.sh
	fi;
fi;
done

echo "$BST Finished bootstrapping Genuine Release";

