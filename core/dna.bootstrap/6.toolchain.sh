# Install linux-headers
# Install man-pages
# Install glibc

#echo "Adjusting toolchain ..."
#if [ -f "/dnatools/bin/ld-new" ]; then
#	mv -v /dnatools/bin/{ld,ld-old}
#	mv -v /dnatools/$(gcc -dumpmachine)/bin/{ld,ld-old}
#	mv -v /dnatools/bin/{ld-new,ld}
#	ln -sv /dnatools/bin/ld /dnatools/$(gcc -dumpmachine)/bin/ld
#fi

cd /dnatools/bin
echo -n "Adjust GNU Autotools </bin/perl> to </usr/bin/perl>:"
for file in autoreconf autoscan automake automake-1.16 autoconf autoheader autom4te autoupdate; do
	grep "/usr/bin/perl" || \
	sed 's/\/bin\/perl/\/usr\/bin\/perl/g' $file > ${file}.new
	mv $file ${file}.old
	mv ${file}.new $file
	rm ${file}.old;
	chmod +x $file;
	echo -n " $file";
done
echo
cd -

echo -n "Readjusting Autoreconf ...";
cp /dnatools/bin/autoreconf /dnatools/bin/autoreconf.old
rm -rf /dnatools/bin/autoreconf.new;
cat /dnatools/bin/autoreconf | sed "s/'aclocal';/'\/dnatools\/bin\/aclocal';/g" | \
sed "s/'libtoolize';/'\/dnatools\/bin\/libtoolize';/g" | \
sed "s/'autopoint';/'\/dnatools\/bin\/autopoint';/g" | \
sed "s/'make';/'\/dnatools\/bin\/make';/g" > /dnatools/bin/autoreconf.new
mv /dnatools/bin/autoreconf.new /dnatools/bin/autoreconf
chmod +x /dnatools/bin/autoreconf
echo " OK";

echo Creating: `dirname $(gcc --print-libgcc-file-name)`/specs

gcc -dumpspecs | sed -e 's@/dnatools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B1 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

