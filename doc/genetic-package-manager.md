
genetic
=======

Este programa é o xestor de paquetes do sistema. Está implementado en bash.

- - - 

Buscar ficheiros e paquetes
---------------------------

Comandos útiles para bus

```shell
genetic -l ${PKG-NAME} # busca paquetes entre os instalados no sistema
genetic -L ${FILE}     # busca a qué paquete dos instalados pertence o ficheiro 
genetic -L bash$       # o comando -L acepta expresións regulares
```

- - -

instalando software con genetic
-------------------------------

### Primeiro paso: obter o codigo fonte


#### Opcion 1: descargar de internet (para usar `genetic -s`)

Unha vez descargado o código fonte, construír o paquete source de genetic.

```shell
wget https://example.com/source-code.tar.gz
genetic -s ${RUTA-AO-TAR-GZ}
```

> O formato pode ser .tar.gz, .tar.bz2, .xz, e moitos outros.
> Genetic esta desenhado para _tragar_ case con calquera cousa existente.

Esta operación xera os ficheiros que precisa o genetic para construír e
instalar o paquete, que se gardan en temporalmente en
**`/var/tmp/genetic/{PKG-NAME}-{PKG-VER}`**.

```shell
# Contido do directorio */var/tmp/genetic/${PKG-NAME}-{PKG-VER}*:
# 
#   /${PKG-NAME}-${PKG-VER} # código fonte orixinal
#   /SrcInfo                # información específica para construír o paquete
#   /${PKG-NAME}/Rules      # "a receta" para construír o paquete (script de bash)
#   /${PKG-NAME}/files      # directorio con "ficheiros extra" a incluír no paquete
#                           # debe estruturase ao igual que a raíz do sistema {etc,var,usr,etc} etcétera
#   IMPORTANTE: hai que instruir a genetic no Rules para que inclua os *files/*
#   cp -av ../$name/files/* $GENPKGDESTDIR/ # habitualmente executado despois de _make install_
#   /${PKG-NAME}/Info       # Información específica para instalar o paquete unha vez construído
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

#### Opcion 2: usar unha fonte que xa existe no hdd (paquete source)

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
no _directorio caché_ de genetic **_/var/cache/genetic_**. Para construír
un paquete:

```shell
cd /var/tmp/genetic/${PKG-NAME}-{PKG-VER}
genetic -b
```

> **PRO TIP**
>
> `genetic --disable-gen-all -b` evita xerar o .src.gen e o .dbg.gen
> De maneira que se acaba moito antes de construír e aforras espazo no hdd

```
# O directorio /var/cache/genetic/PackagePool almacena os paquetes instalables:

# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.gen     # paquete principal (binarios, config, manpages, etcs)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.dev.gen # aka headers (cabeceiras de C, van en /usr/include)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.doc.gen # documentación (o que vai en /usr/share/doc)
# /{PKG-NAME}-{PKG-VER}~{BUILD-REV}.{ARCH}.dbg.gen # paquete principal pero con símboos de debug

# O directorio /var/cache/genetic/SourcePool almacena os paquetes source:

# {PKG-NAME}-{PKG-VER}.src.gen # o source de genetic xunto ao source orixinal
```

> Importante: **NON INSTALAR O DBG**. Hai que instalar todos os paquetes 
> dbg para poder usalos na práctica para o debugging

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

### Imperativo para instalar/actulizar o kernel

Purgar o kernel antes de actulizalo ou instalar un novo para non herdar a basura da
construccion anterior.

```shell
genetic -u linux
genetic -i /var/cache/PackagePool/linux-{PKG-VER}~genuine~{BUILD-REV}.{ARCH}.gen
```

> Pode ser preciso recrear o initramfs co comando `mkinitramfs {KERNEL-VER}-genuine`
> p.ex. `mkinitramfs 4.20.12-genuine`

- - -

> Written by lolo while being instructed by acaogon @ Dom Feb 23 09:25:33 CET 2020
