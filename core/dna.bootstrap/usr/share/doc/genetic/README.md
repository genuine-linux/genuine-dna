Genetic
=======

Genetic is a Software Package Manager developed for Genuine GNU/Linux

Help
----

```
[***] Genuine Package Manager [genetic (16.x.x)].

[***] Usage: genetic --option1 --option2 'args' ... --command|-c 'file'

[***] Commands:

	[-h] --help
	[-v] --version

[***] Options:

	     --admindir   'directory'
	     --color
	     --verbose
	     --force
	[-R] --rebuildb

[***] Source Development Commands:

	     --noarch     '(Create <noarch> package)'
	     --autotools
	     --prefix     'directory'
	     --configure  '--with --enable'
	     --packages   'package1 package2'
	[-s] --source     'source.tar.<gz|bz2|xz>'

	     --noarch     '(Build <noarch> package)'
	     --autotools
	     --disable-gen-orig
	     --disable-gen-source
	     --disable-gen-debug
	     --disable-gen-all
	[-b] --build      'SrcInfo'

	[-c] --clean      'SrcInfo'

[***] Package Management Commands:

	     --noscripts  (Ignore 'PostInst' & 'PreInst' scripts)
	     --instdir    'directory'
	[-i] --install    'package-version.<arch|dev|doc|dbg|src>.gen'

	     --noscripts  (Ignore 'PostRemv' & 'PreRemv' scripts)
	     --instdir    'directory'
	     --purge      (Delete 'package' </etc> files)
	[-u] --uninstall  'package.<dbg|dev>'

	[-l] --list       'pattern'

	     --unpackdir  'directory'
	[-U] --unpack     'package-version.<arch|dev|doc|dbg|src>.gen'

[***] Try 'man genetic.(1)' for more information.

```

==============

Genuine GNU/Linux (c) 2009-2019
