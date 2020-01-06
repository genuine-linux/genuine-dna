Genuine DNA Devel Tools
=======================

**Genuine GNU/Linux DNA Developer Tools** are designed for bootstrap a **Genuine GNU/Linux Developer System**.

If you want to contribute to Genuine GNU/Linux, you should use another Linux system to build it.

# INSTALL

Configure your sudoer user in file "dna.conf".

Run the next commands as "root" user!

Check your host system:

```
./configure
```

Bootstrap a Genuine system:

```
./dna build
```

Once the first stage has finished, you will be prompted into a chrooted environment to finally bootstrap Genuine:

```
./0.chroot.sh
./1.mkdirs.sh
./2.mklinks.sh
./3.mkfiles.sh
./4.shell.sh
./5.env.sh
./6.bootstrap.sh
./8.users.sh
```

If you finished sucessfully latest bootstrap (step 6) you should have a bootable system.

If you need to chroot into your new system you can use the following script:

```
./7.chroot.sh
```

Read more at our [Wiki Pages] (https://github.com/genuine-linux/genuine-dna/wiki).

==============

Genuine GNU/Linux (c) 2009-2019
