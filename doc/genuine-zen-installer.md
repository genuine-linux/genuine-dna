
# WARN #

>
> This is still **EXPERIMENTAL**.
> Don't test it on real disks, use virtual machines.
> You have been warned.

- - -

genuine zen installer
=====================

This program installs genuine linux on a destination disk.

User selects available options throught a zenity-based frontend.

**Features implemented**:

- All user input screens (via zenity)
- Installation procedure, lead by a package list

**Features to be implemented some day**:

- Customize disk partitioning (actually uses a predefined schema)
- Command line arguments (complementary or substitute for zenity inputs)

configuration file
-------------------

The file `vim /etc/genetic/conf.d/installer.conf` holds an
**ordered list** of what packages will be installed in the new
system.


invokation
----------

```shell
genetic -I
```

> Note the uppercase I, in contrast to package installation (-i) flag

- - -

> this Document was writen by lolo, while compiling a kernel for an atom
> @ Sáb Mar 7 04:29:00 CET 2020
