#!/bin/bash

# Genuine DNA 2011

OPTIONS="$1";

# Directories
DNA_DIR=$(pwd); # DNA source directory
INC_DIR="$DNA_DIR/includes"; # Includes and tools directory
SRC_DIR="$DNA_DIR/DNA/Distfiles"; # DNA tree directory
TMP_DIR="$DNA_DIR/tmp"; # Temp directory used for extract sources.
SYS_DIR="$DNA_DIR/system"; # Future Genuine GNU/Linux system directory.
CFG_DIR="$DNA_DIR/etc"; # Config files directory.
LOG_DIR="$DNA_DIR/log"; # Log package build directory.
TOOLBOX_DIR="$SYS_DIR/toolbox"; # Build tools directory.
DNA_RULES="$INC_DIR/dna"; # Rules for build packages directory.

# Package & Patches Files
DNA_PACKAGES_LST=$(cat $CFG_DIR/dna.packages);
DNA_PATCHES_LST=$(cat $CFG_DIR/dna.patches);

# DNA ToolBox
TOOLBOX="/toolbox";
PATH=$TOOLBOX/bin:/bin:/usr/bin

# DNA Utils
EXTRACT="$INC_DIR/extract.sh";

# DNA Legend
INFO=" ** [inf]";
WARN=" !! [wrn]";
BLD=" ** [bld]";
ERROR=" !! [ERR]";

export DNA_DIR INC_DIR SRC_DIR TMP_DIR SYS_DIR LOG_DIR CFG_DIR TOOLBOX_DIR DNA_RULES
export DNA_PACKAGES_LST DNA_PATCHES_LST TOOLBOX PATH EXTRACT INFO WARN BLD ERROR

# DNA Help
function dnahelp {
	echo "";
	echo "./genuine.sh dna_build";
	echo "";
}

# DNA SetEnv
set +h;
umask 022;
LC_ALL=POSIX
GENUINE_TGT=$(uname -m)-genuine-linux-gnu
export LC_ALL GENUINE_TGT

# DNA Intro
echo "";
echo "$INFO Genuine DNA (2011-2014)";
echo "";

# DNA Options

case "$OPTIONS" in
	dna_build) bash $INC_DIR/dna.build;
	;;
	*) dnahelp; exit;
	;;
esac

if [ ! -d "$SYS_DIR/usr/DNA" ]; then
	echo "$INFO Copying DNA to /usr/DNA.";
	mkdir -p $SYS_DIR/usr;
	cp -rf DNA $SYS_DIR/usr/;
	echo "";
fi;

echo "$INFO We're done.";
echo "$INFO Preparing your new Genuine GNU/Linux root tree.";
echo "$WARN Mounting filesystems.";
echo "";
bash $INC_DIR/mount.sh $SYS_DIR;
echo "";

echo "$INFO Now you will be promted to Genuine ToolBox to finish base installation.";
echo ""
echo "$INFO Execute /usr/DNA/Bootstrap/bootstrap_genuine_base.sh & /usr/DNA/Bootstrap/bootstrap_genuine_packages.sh to continue with Genuine GNU/Linux base system installation.";
echo ""

chroot "$SYS_DIR" $TOOLBOX/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:$TOOLBOX/bin:$TOOLBOX/sbin \
    $TOOLBOX/bin/bash --login +h

echo "";
echo "$WARN Umounting filesystems.";
echo "";
bash $INC_DIR/umount.sh $SYS_DIR;
echo "";

unset DNA_DIR INC_DIR SRC_DIR TMP_DIR SYS_DIR LOG_DIR CFG_DIR TOOLBOX_DIR DNA_RULES
unset DNA_PACKAGES_LST DNA_PATCHES_LST TOOLBOX PATH EXTRACT INFO WARN BLD ERROR

exit
