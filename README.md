Genuine DNA Devel Tools
=======================

**Genuine GNU/Linux DNA Developer Tools** are designed for bootstrap a **Genuine GNU/Linux Developer System**.

If you want to contribute to Genuine GNU/Linux, you should use another Linux system to build it.


INSTALL
-------

### Preparation ###

Obtain the toolkit:

```shell
git clone {GENUINE-DNA-REPO}
cd genuine-dna
```

> Run next commands as "root" user!

Create the user account to be used. Configure it at file `dna.conf`.
Default value for user name is `dna`. New user must be added as sudoer.

```shell
useradd dna -m -s /usr/bin/bash -U
vigr
# add user dna to wheel group.
vim dna.conf
# check $USER and $GROUP
```

Move the toolkit to `dna` user's home. Set owner permisions

```
mv genuine-dna /home/dna/
chown -R /home/dna/genuine-dna
cd /home/dna/genuine-dna
```

> If `system/` directory is missing, you must create it.
>  i.e. `mkdir system; chown dna:dna system`.

Check your host system has needed dependencies:

```shell
./configure
```

### Building ###

Bootstrap a Genuine system:

```shell
./dna build
```


**Troubelshooting build failures**

After build failures, there will be files to clean before attemping
to build again:

```shell
# source code (if download was ok, you could mantain it)
rm gensrc/{FAILED-PKG}
# it's recommended to delete the source on failed downloads

rm -r tmp/{FAILED-PKG}-*

rm log/{FAILED-PKG}-*.log
```

General throubleshooting ideas:

- Double check file permission errors.
- Check the link created at `/dnatoolbox` point to `system/`

**While building**

You can check each package build progress via `logs/`,
i.e. `tail -f log/{PKG-NAME}-{STEP}.log`.

Remember to monitor low-resource systems, build could exhaust resources.
exhausted during compilation.

## After succesful build ###

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

- - -

Genuine GNU/Linux (c) 2009-2020
