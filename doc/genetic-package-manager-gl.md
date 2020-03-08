
genetic
=======

Este programa é o xestor de paquetes do sistema. Está implementado en bash.

- - - 

Buscar ficheiros e paquetes
---------------------------

Comandos útiles para buscar paquetes e/ou ficheiros dos paquetes

```shell
genetic -l {PKG-NAME} # busca paquetes entre os instalados no sistema
genetic -L {FILE}     # busca a qué paquete dos instalados pertence o ficheiro 
genetic -L bash$      # o comando -L acepta expresións regulares
```

- - -

Instalando software con `genetic`
---------------------------------

### Primeiro paso: Obter o código fonte


#### Opcion 1: Descargar de internet (para usar `genetic -s`)

> Esta opción é a adecuada para crear novos paquetes

Unha vez descargado o código fonte, construír o paquete source de genetic.

```shell
wget https://example.com/source-code.tar.gz # ou outro mecanismo de descarga
genetic -s source-code.tar.gz
```

> O formato pode ser .tar.gz, .tar.bz2, .xz, e moitos outros.
> Genetic esta deseñado para _tragar_ case con calquera cousa existente.

Esta operación xera os ficheiros que precisa o genetic para construír e
instalar o paquete, que se gardan en temporalmente en
**`/var/tmp/genetic/{PKG-NAME}-{PKG-VER}`**.

```shell
# Contido dun directorio /var/tmp/genetic/{PKG-NAME}-{PKG-VER}:
# 
#   /{PKG-NAME}-{PKG-VER} # código fonte orixinal
#   /SrcInfo              # información específica para construír o paquete
#   /{PKG-NAME}/Rules     # "a receta" para construír o paquete (script de bash)
#   /{PKG-NAME}/files     # directorio con "ficheiros extra" a incluír no paquete
#                         # debe estruturase ao igual que a raíz do sistema {etc,var,usr,etc} etcétera
#   IMPORTANTE: hai que instruir a genetic no Rules para que inclua os *files/*
#   cp -av ../$name/files/* $GENPKGDESTDIR/ # habitualmente executado despois de _make install_
#   /{PKG-NAME}/Info      # Información específica para instalar o paquete unha vez construído
```

##### Comprobar o output! #####

LEE O QUE PON. PETOU? Si petou, **NON** chorarlle a xermade. Mirar o log en:
**`/var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}-configure.log`**.

> TODO comprobar o nome exacto, dice xermy que e algo así, confirmar

Investiga no log cal pode ser a causa do fallo. Habitualmente:

- faltan dependencias
- problemas con opcións do configure:
  - OLLO `systemd` fuera (busca `--disable-systemd` na axuda do configure)
- genetic non recoñece o tipo de source (non atopa configure, makefile, setup.py, etc.)

Pasar ao segundo paso.

#### Opcion 2: Usar unha fonte que xa existe no hdd (paquete source)

Desta maneira aforras a descarga reaproveitando un paquete source que xa
foi construido nun momento anterior.

Os paquetes source de que dispón o sistema almacenanse no cartafol
**`/var/cache/genetic/SourcePool`**. Unha vez localizado o paquete source,
"tragalo" instalandoo con genetic:

```shell
genetic -i /var/cache/genetic/SourcePool/{PKG-NAME}-{PKG-VER}.src.gen
```

Pasar ao segundo paso

- - -

## Segundo paso: construír o paquete (`genetic -b`)

Esta operación xera os paquetes (ficheiros instalables), que se gardan
no _directorio caché_ de genetic **`/var/cache/genetic`**. Para construír
un paquete:

```shell
cd /var/tmp/genetic/{PKG-NAME}-{PKG-VER}
genetic -b
```

> **PRO TIP**
>
> `genetic --disable-gen-all -b` evita xerar o .src.gen e o .dbg.gen
> De maneira que se acaba moito antes de construír e aforras espazo no hdd

```shell
# O directorio /var/cache/genetic/PackagePool almacena os paquetes instalables:

# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.gen     # paquete principal (binarios, config, manpages, etcs)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.dev.gen # aka headers (cabeceiras de C, van en /usr/include)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.doc.gen # documentación (o que vai en /usr/share/doc)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.dbg.gen # paquete principal pero con símboos de debug

# O directorio /var/cache/genetic/SourcePool almacena os paquetes source:

# {PKG-NAME}-{PKG-VER}.src.gen # o source de genetic xunto ao source orixinal
```

> Importante: **NON INSTALAR O `.dbg.gen`**. Hai que instalar todos os paquetes 
> `.dbg.gen` para poder usalos na práctica para o debugging.

### Comprobar a saída!! PETOU? ###

Si petou, **NON** chorarlle a xermade. Mirar o log en:
**`/var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}/{PKG-NAME}-build.log`**
e investigar cal pode ser a causa do fallo. Habitualmente:

- Errores no programa (bugs propios do source code)
- Problemas de compatibilidade con dependencias de paquetes anteriores:
  - non atopa ficheiros
  - ficheiros mal enlazados (links rotos ou que faltan)
  - ficheiros fóra do lugar no que deberan estar

Unha posible solución pasa por recompilar algunha dependencia.

### Ollo: `genetic -c` (clean) ###

Despois de fallar a construcción de paquetes, é importante limpar os ficheiros
residuais:

```shell
cd /var/tmp/genetic/{PKG-NAME}-{PKG-VER}
genetic -c
```

Habitualmente, cando usan `Makefile`:

```shell
cd /var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}-{PKG-VER}
make distclean
```

Outras veces, cando compilan contra un directorio `build`, empregar un 
dos seguintes:

```shell
rm /var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}-{PKG-NAME}/build
rm /var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}-{PKG-NAME}/build.meson
rm /var/tmp/genetic/{PKG-NAME}-{PKG-VER}/{PKG-NAME}-{PKG-NAME}/build.cmake
```

Unha vez construídos os ficheiros instalables, proceder ao terceiro paso

- - -

## Terceiro e último paso: INSTALAR OS PAQUETES (`genetic -i`)

```shell
# As cabeceiras son precisas só para compilar paquetes dependentes

genetic -i /var/cache/genetic/PackagePool/{PKG-NAME}-{PKG-VER}~{BUIL-REV}.{ARCH}.dev.gen

# O paquete principal hai que instalalo sempre, obviamente

genetic -i /var/cache/genetic/PackagePool/{PKG-NAME}-{PKG-VER}~{BUIL-REV}.{ARCH}.gen

# A documentación pódese omitir habitualmente, dado que a referencia de uso
# (manpages/info/o que seña) inclúese no paquete principal

genetic -i /var/cache/genetic/PackagePool/{PKG-NAME}-{PKG-VER}~{BUIL-REV}.{ARCH}.doc.gen
```

- - -

Purgar un paquete do sistema con genetic
----------------------------------------

O proceso implica especificar o nome do paquete, e no caso de que sexa _doc_ ou _dev_
engadir o sufixo que corresponda. Os paquetes _src_ NON se rexistran na base de datos,
ao instalarse extraense ao directorio temporal para podelos construír.

```shell
genetic -u {PKG-NAME}
genetic -u {PKG-NAME}.dev
genetic -u {PKG-NAME}.doc
```

- - -


Actualizar o kernel do sistema con genetic
------------------------------------------


Purgar o kernel antes de actulizalo ou instalar un novo para non herdar a basura da
construccion anterior.

```shell
genetic -u linux
genetic -i /var/cache/PackagePool/linux-{PKG-VER}~genuine~{BUILD-REV}.{ARCH}.gen
```

> Pode ser preciso recrear o initramfs co comando `mkinitramfs {KERNEL-VER}-genuine`
> p.ex. `mkinitramfs 4.20.12-genuine`

* * *

>
> Written by lolo while being instructed by acaogon @ Dom Feb 23 09:25:33 CET 2020
>

* * *


Recompilar o kernel para outra arquitectura (p.ex. Atom)
--------------------------------------------------------

O primeiro é localizar o source do kernel linux no SourcePool da cache de genetic.
O paquete terá un nome parecido a `linux-{PKG-VER}.src.gen`. Outra opción é descargar.

```shell
cd /var/cache/genetic/SourcePool
ls -l | grep linux
# alternativamente wget example.com/linux-*.src.gen
```

Unha vez obtido o source, instalamol, e linkamolo no lugar onde debe estar.


```shell
genetic -i  /var/cache/genetic/SourcePool/linux-4.20.12
cd /var/tmp/genetic/linux-4.20.12
cd /usr/src
ln -sf /var/tmp/genetic/linux-4.20.12/linux-4.20.12 linux
```

Agora importamos a configuración de /boot, e imos ao menu de configuración
para seleccionar a familia do procesador.

```shell
cd /var/tmp/genetic/linux-4.20.12/linux-4.20.12
cp /boot/config-4.20.12-genuine-x86_64 .config
make menuconfig
# alternativamente, make gconfig
```

Unha vez no menú de configuración:

```
> Menú principal
> > Processor type and features  --->
> > > Processor family (Generic-x86-64)  --->
> > > > (x) Intel Atom
> Menu principal
> Gardar en .config
> Saír
```

```shell
cp .config ../linux/files/usr/share/linux/conf/linux-config-atom
make mrproper # limpar toda a cacola
```

>
> **Pro tip**: lee a documentación de gentoo para coñecer máis da configuración
> do kernel.
>
> [Guía instructiva da wiki de gentoo](gentoo) sobre as opcións mínimas precisas
> para compilar un kernel que funcione.

[gentoo]: https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide

### Opcionalmente ###

Neste caso imos a crear un paquete novo que chamaremos `linux-atom`,
que desdenderá do paquete antergo `linux`.

```shell
cd /var/tmp/genetic/linux-4.20.12
cp -a linux linux-atom

vim SrcInfo
# engadimos "package=linux-atom" ao final

cd linux-atom/

vim Info
# cambiamos o nome do paquete a "name=linux-atom"
# "original_name=linux" permanece como estaba, como é lóxico

vim Rules
# cambiamos - GENETIC_KERNEL_VERSION="$version-genuine-$GENETIC_ARCH"
#       por + GENETIC_KERNEL_VERSION="$version-genuine-atom-$GENETIC_ARCH"
# cambiamos - cp -a ../$name/files/usr/share/linux/conf/linux-config .config
#       por + cp -a ../$name/files/usr/share/linux/conf/linux-config-atom .config
```

E finalmente construímos o novo paquete

```shell
cd ..
genetic -b
```

Dado que o paquete `linux` pode construír varios paquetes diferentes
(`linux-headers`, `linux`, e agora tamén `linux-atom`) debemos escoller cal
deles desexamos construír unha vez que genetic remata de xerar o source.

> **PRO TIP**
>
> `tailwait /var/tmp/genetic/linux-4.20.12/linux-atom/linux-atom-build.log`
>
> Agarda a que genetic cree o log de construción e unha vez empeza a construír
> escupe na saída o log. Así non hai que agardar a que cree o ficheiro para
> executar un `tail -f`

* * *

>
> Written by lolo while being instructed (again) by acaogon @ Sáb Mar 7 04:36:22 CET 2020
>
> Lol, I am compiling a kernel *_*
> L.
>

PD: Compilou!

* * *
