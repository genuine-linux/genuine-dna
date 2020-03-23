#!/bin/bash

BST="[<#>]";

echo "$BST BootStrap Genuine Release";

BUILD_ORDER_DB="/etc/genetic/bootstrap/build_order.db";

# Build packages
PKG_BUILD_ORDER=$(grep -v "^#" $BUILD_ORDER_DB);
TOTAL_PKGS=$(grep -v "^#" $BUILD_ORDER_DB | cat -n | awk '{print $1}' | tail -1);
BUILT_PKGS=0;

echo "$BST Need to build $TOTAL_PKGS Genuine packages!";

SOURCEPOOL="/var/cache/genetic/SourcePool";
PACKAGEPOOL="/var/cache/genetic/PackagePool";

for _PKG in $PKG_BUILD_ORDER; do

	PKG_REAL_NAME=$(echo "$_PKG" | awk -F':' '{print $2}');
	PKG=$(echo "$_PKG" | awk -F':' '{print $1}');

	# Package Name & Version
	SRCPKG=$(find $SOURCEPOOL -name "$PKG-*" | awk -F'/' '{print $NF}' | tail -1);

	if [ ! -z "$SRCPKG" ]; then
		echo "$BST Genuine source package for $PKG available: $SRCPKG!";
	else
		echo "$BST ERROR!Can't find a source package for $PKG!";
		exit 1;
	fi;

	PKG_VERSION=$(echo $SRCPKG | awk -F'-' '{print $NF}' | sed -e 's/\.src\.gen//g');
	PKG_NAME=$(echo $SRCPKG | sed -e 's/-'$PKG_VERSION'\.src\.gen//g');

	if [ -z "$PKG_VERSION" ] || [ -z "$PKG_NAME" ]; then
		echo "$BST ERROR! Can't find PKG_NAME or PKG_VERSION!";
		exit 1;
	fi

	# echo "$BST Installing '$PKG_REAL_NAME ($PKG_VERSION)' Genuine sources";

	genetic -i $SOURCEPOOL/$PKG_NAME-$PKG_VERSION.src.gen || exit 1;

	cd /var/tmp/genetic/$PKG_NAME-$PKG_VERSION;

	# echo "$BST Building '$PKG_REAL_NAME ($PKG_VERSION)' Genuine packages";

	genetic --disable-gen-all -b SrcInfo || exit 1;

	((BUILT_PKGS++));

	echo "$BST ($BUILT_PKGS/$TOTAL_PKGS) Genetic packages built!";

	# echo "$BST Installing '$PKG_REAL_NAME ($PKG_VERSION)' Genuine packages";

	find $PACKAGEPOOL -iname "$PKG_REAL_NAME-$PKG_VERSION*.gen" \
		-exec genetic -i {} \;

	INSTALLED_PKGS=$(genetic -l All | grep -v Genetic | wc -l);
	echo "$BST ($INSTALLED_PKGS) Genetic packages installed!";

	# Adjust toolchain after reinstalling glibc #
	if test "$PKG_NAME" == "glibc"; then
		sh /6.toolchain.sh
	fi;
done

echo "$BST Finished bootstrapping Genuine Release";

