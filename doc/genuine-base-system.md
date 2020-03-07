
genuine-base
============

- `/etc/genetic/bootstrap/build_order.db`
: contén unha lista de paquetes a construír para instalar o sistema base,
ordeado en función das dependencias dos paquetes.

- `/usr/src`
: contén os repositorios para desenvolvemento

- `/usr/src/genetic-gensrc`
: este repositorio contén as "recetas" para o empaquetado dos paquetes


openrc (xestor de sysinit)
---------------------------

Estado dos servizos do sistema:

```shell
sudo rc-status #mostra o runlevel "default"
sudo rc-status boot sysinit default # mostra todos os niveis
# etc
```

Deshabilitiar un servizo: `sudo rc-update del {NOME-DEMONIO}`

Habilitar un servizo: `sudo rc-update add {NOME-DEMONIO} default`
(default é o runlevel)

Parar/arrancar un servizo:
`/etc/init.d/{NOME-DEMONIO} stop`
`/etc/init.d/{NOME-DEMONIO} start`
