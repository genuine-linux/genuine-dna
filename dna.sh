#!/bin/bash

#########################
#                       #
# Genuine DNA 2009-2014 #
#                       #
#########################

set +h;
umask 022;

unset CFLAGS
unset CXXFLAGS

OPTIONS="$1";

# Directories
DNA_DIR=$(pwd); # DNA source directory
INC_DIR="$DNA_DIR/includes"; # Includes and tools directory
SRC_DIR="$DNA_DIR/DNA/Distfiles"; # DNA tree directory
TMP_DIR="$DNA_DIR/tmp"; # Temp directory used for extract sources.
SYS_DIR="$DNA_DIR/system"; # Future Genuine GNU/Linux system directory.
LOG_DIR="$DNA_DIR/log"; # Log package build directory.
TOOLBOX_DIR="$SYS_DIR/dnatools"; # DNA Build tools directory.
CROSSTOOLBOX_DIR="$SYS_DIR/dnacrosstools"; # DNA Build tools directory.
DNA_RULES="$INC_DIR/dna"; # Rules for build packages directory.
PATCH_DIR="$INC_DIR/dna.patch.files"; # Patches for build packages.

# DNA ToolBox
TOOLBOX="/dnatools";
CROSSTOOLBOX="/dnacrosstools";

PATH=$TOOLBOX/bin:$CROSSTOOLBOX/bin:/bin:/usr/bin

# Package & Patches Files
DNA_PACKAGES_LST=$(grep -v ^# $INC_DIR/dna.packages);
DNA_PATCHES_LST=$(grep -v ^# $INC_DIR/dna.patches);

# DNA Utilities
EXTRACT="$INC_DIR/extract.sh";

# DNA Legend
INF=" ** [inf]";
WRN=" !! [wrn]";
BLD=" ** [bld]";
ERR=" !! [ERR]";
DBG=" %% [dbg]";

# DNA Set Environment

ARCH=$(uname -m);

LC_ALL=POSIX

GENUINE_HOST=$(echo ${MACHTYPE} | sed -e 's/-[^-]*/-crossgenuine/')

GENUINE_TGT=""
GENUINE_TGT32="i686-pc-linux-gnu"
GENUINE_TGT64="x86_64-genuine-linux-gnu"

BUILD="";
BUILD32="-m32";
BUILD64="-m64";

case $(uname -m) in
        i?86) BUILD="$BUILD32";
		GENUINE_TGT="$GENUINE_TGT32";
        ;;
        x86_64) BUILD="$BUILD64";
		GENUINE_TGT="$GENUINE_TGT64";
        ;;
esac

export LC_ALL GENUINE_TGT GENUINE_TGT64 GENUINE_TGT32 GENUINE_HOST BUILD32 BUILD64 ARCH BUILD
export DNA_DIR INC_DIR SRC_DIR TMP_DIR SYS_DIR LOG_DIR TOOLBOX_DIR CROSSTOOLBOX_DIR DNA_RULES PATCH_DIR
export DNA_PACKAGES_LST DNA_PATCHES_LST TOOLBOX CROSSTOOLBOX PATH EXTRACT INF WRN BLD ERR DBG

# DNA Help
function dnahelp {
	echo "";
	echo "./dna.sh build";
	echo "         clean";
	echo "";
}

#DNA Intro

echo "";
echo "$INF Genuine DNA (2009-2014)";
echo "";

# DNA Options

case "$OPTIONS" in
	build) bash $INC_DIR/dna.build;
	;;
	clean) rm -rvf $TOOLBOX $CROSSTOOLBOX $SYS_DIR/* $TMP_DIR/* $LOG_DIR/* $SRC_DIR/*.tar.*; exit;
	;;
	*) dnahelp; exit;
	;;
esac

if [ ! -d "$SYS_DIR/usr/DNA" ]; then
	echo "$INF Copying DNA to /usr/DNA.";
	mkdir -p $SYS_DIR/usr;
	cp -rf DNA $SYS_DIR/usr/;
	echo "";
fi;

echo "$INF We're done.";
echo "$INF Preparing your new Genuine GNU/Linux root tree.";
echo "$WRN Mounting filesystems."; echo "";
bash $INC_DIR/mount.sh $SYS_DIR;
echo "";

echo "$INF Now you will be promted to Genuine ToolBox to finish base installation.";
echo "";
echo "$INF Execute /usr/DNA/Bootstrap/bootstrap_genuine_base.sh & /usr/DNA/Bootstrap/bootstrap_genuine_packages.sh to continue with Genuine GNU/Linux base system installation.";
echo "";

chroot "$SYS_DIR" $TOOLBOX/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:$TOOLBOX/bin:$TOOLBOX/sbin:$CROSSTOOLBOX/bin:$CROSSTOOLBOX/sbin \
    $TOOLBOX/bin/bash --login +h

echo "";
echo "$WRN Umounting filesystems.";
echo "";
bash $INC_DIR/umount.sh $SYS_DIR;
echo "";

unset DNA_DIR INC_DIR SRC_DIR TMP_DIR SYS_DIR LOG_DIR TOOLBOX_DIR CROSSTOOLBOX_DIR DNA_RULES PATCH_DIR
unset DNA_PACKAGES_LST DNA_PATCHES_LST TOOLBOX CROSSTOOLBOX PATH EXTRACT INFO WARN BLD ERROR

exit
