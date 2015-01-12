#!/dnatools/bin/bash

ln -sv /dnatools/bin/{bash,cat,echo,pwd,stty} /bin
ln -sv /dnatools/bin/perl /usr/bin
ln -sv /dnatools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /dnatools/lib/libstdc++.so{,.6} /usr/lib
sed 's/dnatools/usr/' /dnatools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sv bash /bin/sh
ln -sv /proc/self/mounts /etc/mtab
ln -sv /dnatools/etc/genuine-release /etc/genuine-release
ln -sf /dnatools/bin/file /usr/bin/file

