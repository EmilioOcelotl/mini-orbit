# mini-orbit

Prototipo interactivo audiovisual basado en Raspberry Pi que complementa un proyecto de investigación de la maestría en Tecnología Musical (Facultad de Música, Universidad Nacional Autónoma de México).

## Introducción

Mini-orbit surge a propósito de la realización de dos piezas para instrumentos acústicos, electrónica y video: Altamisa y Leviathan. En este proceso han colaborado: Iracema de Andrade, Alejandro Brianza, Jessica Rodríguez y Esteban Betancur.

Mini-orbit corre en OpenFrameworks y SuperCollider.

## Instalación

Para correr mini-orbit es necesario tener instalado Raspbian en una computadora Raspberry Pi. El sistema no ha sido probado en una sola computadora, así que es necesario distribuir la carga.

### Raspbian

[Distribuciones de Raspbian](https://www.raspberrypi.org/downloads/raspbian/)

[Instrucciones para instalar Raspbian](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

Para correr el sistema interactivo no es necesario entorno gráfico. Recomendamos utilizar la versión lite de Raspbian. 

### Compilación

[Compilar SuperCollider en RPI](https://supercollider.github.io/development/building-raspberrypi)

[Compilar OpenFrameworks en RPI](https://openframeworks.cc/setup/raspberrypi/raspberry-pi-getting-started/)

### SC3-plugins y SCMIR

[Compilar sc3-plugins](https://supercollider.github.io/development/building-raspberrypi#sc3-plugins)

[Compilar SCMIR](https://composerprogrammer.com/code/SCMIR.zip) del repositorio de Nick Collins. Atención con las instrucciones y los cambios en rutas de libgsl.

### Addons 

[ofxOMXPlayer](https://github.com/jvcleave/ofxOMXPlayer)

### Extra: Kernel de Tiempo Real

Un Kernel de Tiempo Real posibilita que el flujo de audio que se procesa en tiempo real no tenga brincos, clics o interrupciones. No es necesario pero es recomendable.

[Instrucciones para compilar un Kernel de Tiempo Real en RPi](https://lemariva.com/blog/2018/07/raspberry-pi-preempt-rt-patching-tutorial-for-kernel-4-14-y)

## Estructura de los archivos

En la carpeta bin/data se encuentran los archivos necesarios para correr la parte de audio. No están incluídos los archivos de audio. Para utilizar otras muestras es necesario modificar las rutas en los archivos de SuperCollider que se encuentran en bin/data/sc

## Contexto del sistema

Mini-orbit retoma de CineVivo retoma la invocación de videos y su ordentamiento en un espacio.
De Orbit, utiliza un parseo sencillo para la utilización de instrucciones en pantalla. En este sentido, la RPI necesita solamente un teclado como interfaz de entrada y una pantalla o un proyector como interfaz de salida. También es posible controlar los parámetros de los elementos en el espacio a través de mensajes OSC. 

La versión actual del prototipo está desarrollada en RPI y Raspbian. El audio puede correr prácticamente en cualquier plataforma que pueda ejecutar SuperCollider, sin embargo, la parte de video solamente puede correr en una Raspberry Pi. Esto debido a que una de las premisas del proyecto de investigación consistió en el desarrollo de este sistema interactivo en computadoras de placa reducida. Por otro lado, las características del hardware de la RPI posibilitan la reproducción de videos con OMXPlayer (exclusivo de RPI). Un proyecto similar con funciones extendidas que puede correr en una computadora de escritorio o laptop es Orbit.
