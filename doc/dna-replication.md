
dna: notas sobre o replicado
============================

Ata o de agora tentar replicar o `dna` dende unha máquina que xa o
contén a un disco que poda bootear noutra máquina é moi *error-prone*.

> De feito, ata o de agora só conseguimos replicar @hozizon con este
> mecanismo.

Este documento pretende ser unha coleción de ideas que podan axudar a
identificar os problemas que impiden o arranque, á que que como bitácora
dos intentos de replicar genuine a un disco.

A efectos deste documento, entenderase que:

- Denomínase *sistema antergo* aquel dende o cal se crea o *novo genetic*.
- Denomínase *novo genetic* aquel sistema que se prepara nun soporte físico coa
  intención de poder bootear outra máquina con genetic.


Problemas con grub
------------------


Este caso ocórrenos ao tentar arrancar @hopes. Despois de moito pelexar coa
consola de rescate do grub queda patente que por algún motivo ao instalar o
cargador de arranque este non colle ben a configuración, e despois de buscar,
probar, e romper un pouco a cabeza, vimos un pouco de luz na seguinte ligazón:

> https://wiki.gentoo.org/wiki/GRUB2/Troubleshooting
>
> **Installing GRUB2 from within a chroot**
> When a separate /boot partition exists, be sure to mount the target root partition before chrooting, but do not mount the /boot partition until after chrooting to the new environment. This is required because grub-mkconfig will not detect /boot as a separate partition and will assume the /boot directory and the root (/) directory are on the same partition. 

Pese a ser un pouco confuso o speech, trátase de que hai que seguir unha secuencia de pasos
moi concreta **na orde que se documenta a continuación** para asegurarse de que o grub recoñece
adecuadamente a partición de `/boot`:

1. Dende o sistema antergo:
  1. montar a raíz do novo genetic
  1. facer chroot ao sistema de ficheros do novo genetic
1. Dende o novo genetic:
  1. montar a partición /boot
  1. rexerar a configuración do grub
  1. rexerar as imaxes initramfs para as versións do kernel que proceda
  1. **desmontar a partición boot** antes de saír
  1. saír do entorno chroot
1. Dende o sistema antergo:
  1. saír do punto de montaxe, e desmontar a raíz do novo genetic
  1. expulsar o disco adecuadamente.

O que se traduce nunha secuencia como a que segue:

```shell
# unha vez conectado o disco...
lsblk                   # comprobar qué dispositivo o contén
umount /dev/sd{x2}      # desmontalo si o entorno o monta automáticamente
mount /dev/sd{x2} /mnt  # montar nun lugar adecuado
cd /mnt                 # ir ao punto de montaxe
./7.chroot.sh           # entrar no entorno chroot

# Coidado, a partición boot é un dispositivo diferente
mount /dev/sd{x1} /boot        # montar a partición boot
ls /boot | grep init           # consultar qué kernels ten o sistema
mkinitramfs 4.20.12-genuine    # rexerar as initramfs dos kernel instalados
mkinitramfs 5.5.6-genuine      # neste caso eran 2

# agora é o momento de actualizar a configuración do grub
grub-mkconfig -o /boot/grub/grub.cfg

# desmontar /boot ANTES DE de saír do chroot
umount /boot
exit

# DESPOIS DE saír do entorno chroot
cd ..               # saír do punto de montaxe
umount /mnt         # desmontar o disco
eject /dev/sd{x}    # expulsar o disco

```

Reinstalar o cargador de arranque
---------------------------------

Entre outros intentos probamos a reinstalar o cargador de arranque no disco.

```shell
# pinchar o disco
lsblk
# umount, si monta o sistema automático

# montar o chroot. OLLO: montar /boot dende dentro do chroot
mount /dev/sd{x2} /mnt
cd /mnt
./7-chroot.sh
mount /dev/sd{x1} /boot
grub-install /dev/sd{x}

# saír adecuadamente do sistema chroot
umount /boot
exit

# expulsar adecuadamente o disco
cd ..
umount /mnt
eject /mnt
```

Problemas con paquetes
----------------------

Pese a que o do grub era un problema, unha vez avanzado no troubleshooting
xurden problemas con algúns paquetes concretos, a saber:

- util-linux (`mount` fallaba con opcodes)
- udev (é quen genera os sistema de ficheiros `/dev`)

Nestes casos a solución pasa por recompilar os paquetes no sistema antergo,
reinstalar no sistema antergo, e reinstalar no novo genetic por medio de
chroot.


Problemas co hardware
---------------------

Pese a non ser o máis habitual, sempre pode darse o caso de que algún dispositivo
estea tocado. Unha das probas que fixemos foi dumpear o pendrive co que fixemos
probas a un disco SATA dos pequenos.

> Neste caso copiamos en bloques de 2048 para acabar antes, dado que eran 32Gb.
> Xermade recomenda 1024, sendo o normal 512.

```shell
dd if=/dev/sdb of=/dev/sdc bs=2048 count=60995326 conv=sync,noerror status=progress
```

Tardou ~ 60mins en clonar os 32 gb do pendrive (ambas unidades via USB).
Neste caso non serviu para bootear con éxito. Inda así o intento
axuda a idear alternativas, pois pese a fallar no arranque de forma
moi similar o erro é lixeiramente distinto.

Por exemplo, poderíamos clonar o disco de @horizon, que ata agora é a única
máquina na que replicamos con éxito o genuine a través dun disco físico.

> Caímos na conta de que non actualizamos os initramfs despois de reinstalar o udev,
> pero xa era hora de deixar para utro momento:
>
> - actualizar initramfs
> - rexerar a configuracion do grub
> - comprobar que os uuids da conf do grub son os correctos para o novo disco

- - -

> O relato anterior é sobre os *intentos de replicar genetic* en @hopes cun disco,
> mentras @shitbook constrúe un dna para atom, en Vilares, durante outra sesión
> nocturna de @acaogon e @lolo o Sáb Mar 7 21:34:30 CET 2020

- - -
