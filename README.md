# mini-orbit

Prototipo interactivo audiovisual basado en Raspberry Pi que complementa un proyecto de investigación de la maestría en Tecnología Musical (Facultad de Música, Universidad Nacional Autónoma de México).

## Introducción

Mini-orbit surge a propósito de la realización de dos piezas para instrumentos acústicos, electrónica y video: Altamisa y Leviathan. En este proceso han colaborado: Iracema de Andrade, Alejandro Brianza, Jessica Rodríguez y Esteban Betancur.

La parte visual del prototipo corre sobre OpenFrameworks y la sonora, sobre SuperCollider.

La versión actual del prototipo está desarrollada en RPI y Raspbian. El audio puede correr prácticamente en cualquier plataforma que pueda ejecutar SuperCollider, sin embargo, la parte de video solamente puede correr en una Raspberry Pi. Esto debido a que una de las premisas del proyecto de investigación consistió en el desarrollo de este sistema interactivo en computadoras de placa reducida. Por otro lado, las características del hardware de la RPI posibilitan la reproducción de videos con OMXPlayer (exclusivo de RPI). Un proyecto similar con funciones extendidas que puede correr en una computadora de escritorio o laptop es Orbit. 

## Antecedentes

De CineVivo retoma la invocación de videos y su ordentamiento en un espacio.
De Orbit, utiliza un parseo sencillo para la utilización de instrucciones en pantalla. En este sentido, la RPI necesita solamente un teclado como interfaz de entrada y una pantalla o un proyector como interfaz de salida. También es posible controlar los parámetros de los elementos en el espacio a través de mensajes OSC. 

## Instalación

### Compilación 

[Instalar SuperCollider en RPI](https://supercollider.github.io/development/building-raspberrypi)
[Compilar OpenFrameworks](https://openframeworks.cc/setup/raspberrypi/raspberry-pi-getting-started/)

### Addons

[ofxOMXPlayer](https://github.com/jvcleave/ofxOMXPlayer)

## Funcionamiento

vload 1 nombreDelArchivo // instrucción básica para cargar un archivo. En mini-orbit es necesario agregar la extensión del archivo