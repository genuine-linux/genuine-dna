
genetic
=======

Este programa e o xestor de paquetes do sistema. Esta implementado en bash

- - - 

Buscar ficheiros e paquetes
---------------------------

genetic -l ${PKG-NAME} # busca paquetes dos instalados no sistema
genetic -L ${FILE}     # busca a qué paquete dos instalados pertence o ficheiro 
genetic -L bash$       # o comando -L acepta expresións regulares 

- - -

instalando software con genetic
-------------------------------

### Primeiro paso: obter o codigo fonte


#### Opcion 1: descargar de internet (para usar genetic -s)

o formato pode ser .tar.gz, .tar.bz2, .xz, e moitos outros.
Genetic esta desenhado para _tragar_ case con calquera cousa existente.

wget https://acaogon-reinventou-a.polvora/codigo-fonte.tar.gz

De seguido, construír o source de genetic. Esta operación xera os ficheiros
que precisa o genetic para construír e instalar o paquete, que se gardan en
temporalmente en */var/tmp/genetic/${PKG-NAME}-{PKG-VER}*.

genetic -s ${RUTA-AO-TAR-GZ}

> Contido do directorio */var/tmp/genetic/${PKG-NAME}-{PKG-VER}*:
> 
>   /${PKG-NAME}-${PKG-VER} # código fonte orixinal
>   /SrcInfo                # información específica para construír o paquete
>   /${PKG-NAME}/Rules      # "a receta" para construír o paquete (script de bash)
>   /${PKG-NAME}/files      # directorio con "ficheiros extra" a incluír no paquete
>                           # debe estruturase ao igual que a raíz do sistema {etc,var,usr,etc} etcétera
>   # IMPORTANTE: hai que instruir a genetic no Rules para que inclua os *files/*
>   _cp -av ../$name/files/* $GENPKGDESTDIR/_ # habitualmente executado despois de _make install_
>   /${PKG-NAME}/Info       # Información específica para instalar o paquete unha vez construído
```
### Comprobar o output! ###

LEE O QUE PON. PETOU? Si petou, **NON** chorarlle a xermade. Mirar o log en:

**/var/tmp/genetic/${PKG-NAME}-{PKG-VER}/${PKG-NAME}-configure.log**

> TODO comprobar o nome exacto, dice xermy que e algo así, confirmar

Investiga no log cal pode ser a causa do fallo. Habitualmente:

- faltan dependencias
- problemas con opcións do configure:
  - OLLO systemd fuera (busca *--disable-systemd* na axuda do configure)
- genetic non recoñece o tipo de source (non atopa configure, makefile, setup.py, etc.)

Pasar ao segundo paso.

#### Opcion 2: usar unha fonte que xa existe no hdd (paquete source)

Desta maneira aforras a descarga reaproveitando un paquete source que xa
foi construido nun momento anterior.

Os paquetes source de que dispon o sistema almacenanse no cartafol
*/var/cache/genetic/SourcePool*.`Unha vez localizado o paquete source,
"tragalo" instalandoo con genetic:

*genetic -i /var/cache/genetic/SourcePool/${PKG-NAME}-${PKG-VER}*

Pasar ao segundo paso

- - -

## Segundo paso: construír o paquete (genetic -b)


Esta operación xera os paquetes (ficheiros instalables), que se gardan
no _directorio cache_ de genetic **/var/cache/genetic**
```
cd /var/tmp/genetic/${PKG-NAME}-{PKG-VER}
genetic -b

> **PRO TIP**
>
> _genetic --disable-gen-all -b_` evita xerar o .src.gen e o .dbg.gen
> De maneira que se acaba moito antes de construír e aforras espazo no hdd
```
O directorio _/var/cache/genetic/PackagePool_ almacena:

> ${PKG-NAME}-${PKG-VER}~${BUILD-REV}.${ARCH}.gen     # paquete principal (binarios, config, manpages, etcs)
> ${PKG-NAME}-${PKG-VER}~${BUILD-REV}.${ARCH}.dev.gen # aka headers (cabeceiras de C, van en /usr/include)
> ${PKG-NAME}-${PKG-VER}~${BUILD-REV}.${ARCH}.doc.gen # documentación (o que vai en /usr/share/doc)
> ${PKG-NAME}-${PKG-VER}~${BUILD-REV}.${ARCH}.dbg.gen # pauete principal pero con símboos de debug
```
O directorio _/var/cache/genetic/SourcePool_ almacena os paquetes source

> ${PKG-NAME}-${PKG-VER}.src.gen # o source de genetic xunto ao source orixinal

> Importante: **NON INSTALAR O DBG**. Hai que instalar todos os paquetes 
> dbg para poder usalos na práctica para o debugging

### Comprobar a saida!! PETOU? ###

Si petou, **NON** chorarlle a xermade. Mirar o log en:

_/var/tmp/genetic/${PKG-NAME}-{PKG-VER}/${PKG-NAME}/${PKG-NAME}-build.log_

**e investigar cal pode ser a causa do fallo**. Habitualmente:

- Errores no programa (bugs propios do source code)
- Problemas de compatibilidade con dependencias de paquetes anteriores:
  - non atopa ficheiros
  - ficheiros mal enlazados (links rotos ou que faltan)
  - ficheiros fóra do lugar no que deberan estar

Unha posible solución pasa por recompilar algunha dependencia.

### Ollo: genetic -c (clean) ###

Despois de fallar a construcción de paquetes, é importante limpar os ficheiros
residuais:

cd /var/tmp/genetic/${PKG-NAME}-${PKG-VER}
genetic -c

Habitualmente, cando usan Makefile:

cd /var/tmp/genetic/${PKG-NAME}-${PKG-VER}/${PKG-NAME}-${PKG-NAME}
make distclean

Outras veces, cando compilan contra un directorio "build":

rm /var/tmp/genetic/${PKG-NAME}-${PKG-VER}/${PKG-NAME}-${PKG-NAME}/build
rm /var/tmp/genetic/${PKG-NAME}-${PKG-VER}/${PKG-NAME}-${PKG-NAME}/build.meson
rm /var/tmp/genetic/${PKG-NAME}-${PKG-VER}/${PKG-NAME}-${PKG-NAME}/build.cmake

Unha vez construídos os ficheiros instalables, proceder a...

- - -

## Terceiro e último paso: INSTALAR OS PAQUETES

```
1. As cabeceiras son precisas só para compilar paquetes dependentes

genetic -i /var/cache/genetic/PackagePool/${PKG-NAME}-${PKG-VER}~${BUIL-REV}.${ARCH}.dev.gen

2. O paquete principal hai que instalalo sempre, obviamente

genetic -i /var/cache/genetic/PackagePool/${PKG-NAME}-${PKG-VER}~${BUIL-REV}.${ARCH}.gen

3. A documentación pódese omitir habitualmente, dado que a referencia de uso
  (manpages/info/o que seña) inclúese no paquete principal

genetic -i /var/cache/genetic/PackagePool/${PKG-NAME}-${PKG-VER}~${BUIL-REV}.${ARCH}.doc.gen

- - -

Purgar un paquete do sistema con genetic
----------------------------------------

O proceso implica especificar o nome do paquete, e no caso de que sexa _doc_ ou _dev_
engadir o sufixo que corresponda. Os paquetes _src_ NON se rexistran na base de datos,
ao instalarse extraense ao directorio temporal para podelos construír.

genetic -u {$PKG-NAME}
genetic -u {$PKG-NAME}.dev
genetic -u {$PKG-NAME}.doc

## Imperativo para instalar/actulizar o kernel

Purgar o kernel antes de actulizalo ou instalar un novo para non herdar a basura da
construccion anterior.

genetic -u linux
genetic -i /var/cache/PackagePool/linux-${PKG_VER}~genuine~${BUILD_REV}.${ARCH}.gen

> Pode ser preciso recrear o initramfs co comando *mkinitramfs 4.20.12-genuine*

- - -
```
> Written by lolo while being instructed by acaogon @ Dom Feb 23 09:25:33 CET 2020
