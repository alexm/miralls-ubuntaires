Servidor de miralls per a festes d'instal·lació
===============================================

Maquinari
---------

*   Un llapis USB o un CD amb l'instal·lador d'Ubuntu Server, segons si el portàtil té unitat de CD.
*   Un ordinador portàtil que pugui arrencar un disc dur del port USB i que tingui connexió WiFi.
*   Un disc dur extern amb connexió USB (com a mínim del 500 GB) i preferiblement de 2.5" perquè no calgui carregar la font d'alimentació.
*   Un cable USB per endollar el disc dur extern en un port USB del portàtil.
*   Un cable de xarxa creuat o un de directe, si el portàtil és capaç de fer crossover automàticament (la majoria d'ordinadors moderns ja tenen aquesta característica).

Programari
----------

*   Ubuntu Server
*   lvm2
*   dnsmasq
*   iptables
*   apt-mirror
*   apache2

Instal·lació bàsica del servidor
--------------------------------

*   Endolleu el disc dur extern en un port USB del portàtil amb el cable USB.
*   Arrenqueu el portàtil i feu que s'iniciï la instal·lació de l'Ubuntu Server des del llapis USB o del CD, segons s'escaigui.
*   Feu una instal·lació normal fins que arribeu a la selecció del disc.
*   Trieu un particionat amb LVM sobre el disc dur extern que teniu endollat al port USB.
*   La taula de particions del disc ha de contenir 2 particions primàries:
    *   La primera de tipus Linux (83) per al /boot amb mida entre 250 MB.
    *   La segona de tipus Linux LVM (8e) per al sistema amb la resta del disc.
    *   La segona partició serà el volum físic d'un grup de volums anomenat ubuntaires, que conté aquests volums lògics:
    *   *   root per al sistema, amb 8 GB.
        *   swap per al fitxer d'intercanvi, amb 2 GB.
        *   mirror per als miralls, amb la mida que calculeu que us cal (uns quants centenars de GB).
    *   No assigneu tot l'espai disponible als miralls per si us cal ampliar algun dels altres volums lògics en algun moment.
    *   Formateu la partició de /boot i els volums lògics amb el sistema de fitxers ext3 o ext4.
*   Quan l'instal·lador us demani quin usuari voleu crear, indiqueu-li que es diu ubuntaires i la contrasenya ubuntu.cat (si us interessa que algú pugui connectar remotament a aquest ordinador, trieu una contrasenya més robusta).
*   Quan l'instal·lador us demani quins serveis voleu instal·lar, indiqueu-li que cap (en concret, desactiveu el servei SSH si voleu que ningú pugui connectar remotament).

Serveis del servidor
--------------------

*   dnsmasq
    *   interfaces
    *   dnsmasq.conf
*   iptables
    *   iptables-nat
*   apt-mirror
    *   mirror-list
    *   dist-upgrader-all
*   apache2

Configuració dels miralls
-------------------------

TBD

Actualització dels miralls
--------------------------

*   Convertiu-vos en root:

    $ sudo -i

*   Obtingueu una IP pel cable:

    # dhclient eth2

*   Genereu la llista de fonts del mirall:

    # /usr/local/bin/mirror-list > /etc/apt/mirror.list

*   Actualitzeu el mirall:

    # su - apt-mirror -c apt-mirror

*   Si avorteu la sincronització del mirall i us cal esborrar el bloqueig, feu:

    # rm ~apt-mirror/var/apt-mirror.lock

Neteja dels miralls obsolets
----------------------------

Després d'una actualització o purga d'un mirall us pot interessar fer net:

    $ sudo ~apt-mirror/var/clean.sh

Introducció de nous miralls
---------------------------

Editeu l'ordre mirror-list i afegiu la nova distribució a la llista *dists*.

Preparació de la festa
======================

Servidor
--------

*   Poseu en marxa la interfície LAN:

    $ sudo ifconfig eth2 10.0.0.10 netmask 255.0.0.0

*   Encengueu el dnsmasq:

    $ sudo invoke-rc.d dnsmasq restart

*   Encengueu l'apache:

    $ sudo invoke-rc.d apache2 restart

*   Si voleu fer NAT amb la WiFi:

    $ sudo /usr/local/bin/iptables-nat

Clients
-------

*   Desactiveu els repositoris de fonts (sources).
*   Desactiveu els repositoris de tercers (canonical, medibuntu, etc.)
*   Desactiveu els repositoris de backports i proposed.
*   Activeu algun respositori de la llista següent:
    *   http://archive.ubuntu.com/ubuntu
    *   http://ad.archive.ubuntu.com/ubuntu
    *   http://es.archive.ubuntu.com/ubuntu
    *   http://us.archive.ubuntu.com/ubuntu
    *   http://ftp.caliu.cat/ubuntu