#!/toolbox/bin/bash

echo ""
echo " * [---] Bootstraping Genuine Xorg Window System ...";
echo ""

# Install Genetic
NEED_XORG_SOURCES="1";
XORG_SOURCES_PATH="/root/Xorg";

# Install base system
SOURCEPOOL="/usr/Genetic/SourcePool";
PACKAGEPOOL="/usr/Genetic/PackagePool";

XORG_PACKAGES="applewmproto \
bigreqsproto \
compositeproto \
damageproto \
dmxproto \
dri2proto \
fixesproto \
randrproto \
recordproto \
renderproto \
resourceproto \
scrnsaverproto \
glproto \
inputproto \
kbproto \
videoproto \
windowswmproto \
videoproto \
xcb-proto \
xcmiscproto \
xextproto \
xf86bigfontproto \
xf86dgaproto \
xf86driproto \
xf86vidmodeproto \
xineramaproto \
xproto \
util-macros \
encodings \
bdftopcf \
iceauth \
libAppleWM \
libdmx \
libfontenc \
libFS \
libICE \
libpciaccess \
libpthread-stubs \
libSM \
libWindowsWM \
libX11 \
libXau \
libXaw \
libxcb \
libXcomposite \
libXcursor \
libXdamage \
libXdmcp \
libXext \
libXfixes \
libXfont \
libXft \
libXi \
libXinerama \
libxkbfile \
libXmu \
libXpm \
libXrandr \
libXrender \
libXres \
libXScrnSaver \
libXt \
libXtst \
libXv \
libXvMC \
libXxf86dga \
libXxf86vm \
luit \
makedepend \
mkfontdir \
mkfontscale \
font-adobe-100dpi \
font-adobe-75dpi \
font-adobe-utopia-100dpi \
font-adobe-utopia-75dpi \
font-adobe-utopia-type1 \
font-alias \
font-arabic-misc \
font-bh-100dpi \
font-bh-75dpi \
font-bh-lucidatypewriter-100dpi \
font-bh-lucidatypewriter-75dpi \
font-bh-ttf \
font-bh-type1 \
font-bitstream-100dpi \
font-bitstream-75dpi \
font-bitstream-type1 \
font-cronyx-cyrillic \
font-cursor-misc \
font-daewoo-misc \
font-dec-misc \
font-ibm-type1 \
font-isas-misc \
font-jis-misc \
font-micro-misc \
font-misc-cyrillic \
font-misc-ethiopic \
font-misc-meltho \
font-misc-misc \
font-mutt-misc \
font-schumacher-misc \
font-screen-cyrillic \
font-sony-misc \
fontsproto \
font-sun-misc \
font-util \
font-winitzki-cyrillic \
font-xfree86-type1 \
sessreg \
setxkbmap \
smproxy \
x11perf \
xauth \
xbacklight \
xbitmaps \
xcmsdb \
xcursorgen \
xcursor-themes \
xdpyinfo \
xdriinfo \
xev \
xf86-input-acecad \
xf86-input-aiptek \
xf86-input-evdev \
xf86-input-joystick \
xf86-input-keyboard \
xf86-input-mouse \
xf86-input-synaptics \
xf86-input-vmmouse \
xf86-input-void \
xf86-video-apm \
xf86-video-ark \
xf86-video-ast \
xf86-video-ati \
xf86-video-chips \
xf86-video-cirrus \
xf86-video-dummy \
xf86-video-fbdev \
xf86-video-geode \
xf86-video-glide \
xf86-video-glint \
xf86-video-i128 \
xf86-video-i740 \
xf86-video-intel \
xf86-video-mach64 \
xf86-video-mga \
xf86-video-neomagic \
xf86-video-newport \
xf86-video-nv \
xf86-video-openchrome \
xf86-video-r128 \
xf86-video-rendition \
xf86-video-s3 \
xf86-video-s3virge \
xf86-video-savage \
xf86-video-siliconmotion \
xf86-video-sis \
xf86-video-sisusb \
xf86-video-suncg14 \
xf86-video-suncg3 \
xf86-video-suncg6 \
xf86-video-sunffb \
xf86-video-sunleo \
xf86-video-suntcx \
xf86-video-tdfx \
xf86-video-tga \
xf86-video-trident \
xf86-video-tseng \
xf86-video-v4l \
xf86-video-vesa \
xf86-video-vmware \
xf86-video-voodoo \
xf86-video-wsfb \
xf86-video-xgi \
xf86-video-xgixp \
xgamma \
xhost \
xinput \
xkbcomp \
xkbevd \
xkbutils \
xkill \
xlsatoms \
xlsclients \
xmodmap \
xorg-docs \
xorg-server \
xorg-sgml-doctools \
xpr \
xprop \
xrandr \
xrdb \
xrefresh \
xset \
xsetroot \
xtrans \
xvinfo \
xwd \
xwininfo \
xwud";


rm -rf /var/tmp/*


for xorg_package in $XORG_PACKAGES; do

	if [ ! -d "/var/cache/gens/$xorg_package" ]; then

		# Generate G1.src.gen
		xorg_source_package=$(find $XORG_SOURCES_PATH -iname "$xorg_package*" -type f);
		cd $XORG_SOURCES_PATH;
		gen -s $xorg_source_package "$xorg_package";
	
		cd /var/tmp

		srcdir=$(find . -iname "${xorg_package}*" -type d);

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

       		pkggen=$(find $PACKAGEPOOL -iname "${xorg_package}*" -type f -exec ls -lrt {} \; | tail -1 | awk '{print $NF}');

       		gen -i $pkggen;

		echo "";
	else
        	echo " * [---] Package $xorg_package already installed."
	fi;
done

echo ""
echo " * [---] Build complete.";
echo ""
