# mini-orbit

Prototipo interactivo audiovisual basado en Raspberry Pi que complementa un proyecto de investigación de la maestría en Tecnología Musical (Facultad de Música, Universidad Nacional Autónoma de México).

## Introducción

Mini-orbit surge a propósito de la realización de dos piezas para instrumentos acústicos, electrónica y video: Altamisa y Leviathan. En este proceso han colaborado: Iracema de Andrade, Alejandro Brianza, Jessica Rodríguez y Esteban Betancur.

Mini-orbit corre en OpenFrameworks y SuperCollider.

## Instalación

Para correr mini-orbit es necesario tener instalado Raspbian en una computadora Raspberry Pi. 
El sistema ha sido probado en una sola computadora. 

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

## Materiales y estructura de los archivos

En la carpeta bin/data/ se encuentra una liga simbólica que lleva a la carpeta video. En esta carpeta es posible colocar los videos a cargar. En el archivo de SuperCollider es posible cambiar la ruta que lleva a los archivos de audio que el sistema utilizará. Una tercera carpeta también conduce a los archivos que el sistema graba y analiza en cada ejecución. La ruta de esta carpeta se comparte con la de los archivos fijos.  

En la carpeta bin/data se encuentran los archivos necesarios para correr la parte de audio. No están incluídos los archivos de audio. Para utilizar otras muestras es necesario modificar las rutas en los archivos de SuperCollider que se encuentran en bin/data/sc

## Contexto del sistema

Mini-orbit retoma de CineVivo retoma la invocación de videos y su ordentamiento en un espacio.
De Orbit, utiliza un parseo sencillo para la utilización de instrucciones en pantalla. En este sentido, la RPI necesita solamente un teclado como interfaz de entrada y una pantalla o un proyector como interfaz de salida. También es posible controlar los parámetros de los elementos en el espacio a través de mensajes OSC. 

La versión actual del prototipo está desarrollada en RPI y Raspbian. El audio puede correr prácticamente en cualquier plataforma que pueda ejecutar SuperCollider, sin embargo, la parte de video solamente puede correr en una Raspberry Pi. Esto debido a que una de las premisas del proyecto de investigación consistió en el desarrollo de este sistema interactivo en computadoras de placa reducida. Por otro lado, las características del hardware de la RPI posibilitan la reproducción de videos con OMXPlayer (exclusivo de RPI). Un proyecto similar con funciones extendidas que puede correr en una computadora de escritorio o laptop es Orbit.

## Referencias

