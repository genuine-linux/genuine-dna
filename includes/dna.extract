#!/bin/bash

SRC_PACKAGE_NAME="$1";
SDK_PACKAGE_VERSION="$2";

if [ "$SRC_PACKAGE_NAME" == "" ] || [ "$SDK_PACKAGE_VERSION" == "" ]; then
	echo "$WRN Nothing to extract!";
else

	TYPE=$(echo $SRC_PACKAGE_NAME | awk -F"." '{print $NF}');

	if [ -d "$TMP_DIR/$SDK_PACKAGE_VERSION" ]; then
		echo "$WRN Deleting old $TMP_DIR/$SDK_PACKAGE_VERSION";
		rm -rf $TMP_DIR/$SDK_PACKAGE_VERSION;
	fi

	echo "$INF Extract $SRC_PACKAGE_NAME to $TMP_DIR/$SDK_PACKAGE_VERSION";

	case $TYPE in
		bz2) tar jxf $SRC_PACKAGE_NAME -C $TMP_DIR/;
		;;
		gz) tar zxf $SRC_PACKAGE_NAME -C $TMP_DIR/;
		;;
		xz) tar -xf $SRC_PACKAGE_NAME -C $TMP_DIR/;
		;;
		*) echo "$ERR Extract: Unknown file type.";
		;;
	esac;
fi;
