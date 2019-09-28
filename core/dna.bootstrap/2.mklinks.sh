ln -sv /dnatools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin
ln -sv /dnatools/bin/{env,install,perl,printf,file,bison}    /usr/bin
ln -sv /dnatools/lib/libgcc_s.so{,.1}                  /usr/lib
ln -sv /dnatools/lib/libstdc++.{a,so{,.6}}             /usr/lib
ln -sv /dnatools/lib/gcc /usr/lib
sed 's/dnatools/usr/' /dnatools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv /dnatools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncursesw.so.6 /usr/lib/libncurses.so
ln -sf /dnatools/lib/libfl.so.2 /lib/libfl.so.2
ln -sfv /lib/libfl.so.2 /lib/libfl.so
ln -sv bash /bin/sh
ln -sv /proc/self/mounts /etc/mtab
ln -sv flex /dnatools/bin/lex

