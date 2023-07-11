# Clase umemoria v1.6.1 - Memorias y Tesis; FCFM; UChile

23-09-2021

Se puede usar la clase `umemoria` para memorias y tesis (de magíster o de doctorado) de la FCFM, UChile.

## Requisitos
El requisito principal para usar esta clase es, por supuesto, una distribución de LaTeX funcionando.
En Windows se recomienda MiKTeX 2.8 o superior y TeXLive 2009 o superior en Linux u OS X.

Para el correcto funcionamiento de la clase, adicionalmente a la distribución de LaTeX, deberán estar
instalados los siguientes packages:
* `inputenc`
* `geometry`
* `amsmath`, `amssymb`, `amsthm`
* `graphicx`
* `caption`
* `appendix`
* `babel`
* `hyperref`
* `listings`
* `pgffor`
* `etoolbox`
* `lipsum` (solo para compilar el documento `main.tex` de ejemplo)

Para instrucciones de cómo instalar estos packages en su distribución, por favor consulte el manual de la misma.

Otra opción es usar [la plantilla en Overleaf](https://www.overleaf.com/latex/templates/memoria-tesis-slash-fcfm-slash-uchile/scfhvdjsvhvs). 

(En caso de haber usado la versión 1.6, hubo un bug cuando se quitaba el comando `\tesis{...}`. Para resolver ese problema, se puede reemplazar el archivo `umemoria.cls` con la versión actualizada acá y debería desparecer el problema.)

## Modo de Uso
Se puede bajar el repositorio, abrir el archivo `main.tex` y compilarlo con `pdflatex` (o algo parecido).

### Opciones
La clase `umemoria` cuenta con variadas opciones. En primer lugar, cabe notar que se heredan todas las opciones de la clase `book`. Se pasan por defecto las opciones `12pt`,`letterpaper`,`oneside`, a la clase `book` pero las opciones como `fleqn`, `leqno`, etc., también se encuentran disponibles. Además, se agregan las siguientes a la clase `umemoria`:

* `english`: Use English titles for Table of Contents, Bibliography, etc.
* `leftnum`: Coloca la numeración de los Teoremas, Definiciones, etc. a la izquierda.
* `rightnum`: (por defecto): Coloca la numeración de los Teoremas, Definiciones, etc. a la derecha.
* `contnum`: (por defecto): Activa la numeración correlativa entre los ambientes de tipo teorema.
* `nocontnum`: Desactiva la numeración correlativa entre los ambientes de tipo teorema.
* `uprightd`: Transforma todas las letras 'd' en modo matemático a fuente normal, no cursiva.
* `uprighte`: Transforma todas las letras 'e' en modo matemático a fuente normal, no cursiva.
* `uprighti`: Transforma todas las letras 'i' en modo matemático a fuente normal, no cursiva.
* `upright`: Activa las tres opciones anteriores.

Estas opciones están desactivadas por defecto. Para agregar una o más opciones, se puede usar `\documentclass[opt1,opt2]{umemoria}`, etc.

### Comandos
La clase provee los siguientes comandos, proporcionados para definir parámetros necesarios para la generación de la portada, etc.

* `\depto{texto}`: Departamento al que pertenece el autor.
* `\author{texto}`: Nombre del autor.
* `\title{texto}`: Título del trabajo. Debe estar escrito SIN fines de línea (`\\`).
* `\memoria{texto}` [opcional]: Nombre del título optado en el caso de una memoria. (Algo como "Ingeniero/a Civil en ...")
* `\tesis{texto}` [opcional]: Nombre del grado optado. Se puede combinar este comando con `\memoria{texto}` en el caso de una doble titulación. (Algo como "Magíster en ..." o "Doctor en ...".)
* `\cotutela{texto}` [opcional]: Nombre de la otra institución de cotutela en el caso de una tesis (si aplica).
* `\guia{texto}`: Nombre del profesor guía. Se pueden incluir dos o más profesores seperados por coma.
* `\coguia{texto}` [opcional]: Nombre del profesor co-guía (si aplica). Se pueden incluir dos o más profesores co-guía seperados por coma.
* `\comision{profe1, profe2, profeN}`: Nombres de los integrantes de la comisión evaluadora. Se pueden omitir argumentos.
* `\auspicio{texto}` [opcional]: Indica qué institucion u otro texto incluir en el anuncio de auspicio (si aplica).
* `\anho{texto}` [opcional]: El año en que se va a dar el examen de grado. Por defecto, será el año actual.

Todos los comandos convierten sus argumentos a mayúsuclas, a excepción del auspicio.

### Entornos
Se definen además entornos que ayudan a dar un formateo adecuado a cada parte de la memoria/tesis, además de ayudar a mantener una coherencia semántica en el código.

* `\begin{resumen}` `\end{resumen}`: Delimita la sección de Resumen de la memoria/tesis.
* `\begin{abstract}` `\end{abstract}` [opcional]: Creates a section for Abstract (in English) in the memoria/tesis. Both `resumen` (in Spanish) and `abstract` (in English) should be provided when the document is in English. (Only `resumen` is required when the document is in Spanish.)
* `\begin{dedicatoria}` `\end{dedicatoria}`: Delimita la dedicatoria. El texto se escribe en cursiva, alineado horizontalmente a la izquierda y centrado verticalmente.
* `\begin{thanks}` `\end{thanks}`: Sección de agradecimientos.

#### Entornos matemáticos
Además, se definen entornos 'matemáticos' que permiten agergar teoremas, definiciones, etc. de manera ordenada y coherente con el estilo del texto. Estos entornos son:

* `defn`: Definicion.
* `teo`: Teorema.
* `cor`: Corolario.
* `lema`: Lema.
* `prop`: Proposicion.
* `ej`: Ejemplo.
* `obs`: Observacion.
* `proof`: Demostración. Se agrega automáticamente el símbolo de término de la demostración al final de esta.

Por defecto, cada uno de estos entornos tiene una numeración correlativa e intercapítulos, es decir, escribir un teorema, una definición y luego otro teorema en el capítulo 1 y luego otro teorema en el capítulo 2 tendrá como resultado lo siguiente:

	Teorema 1.1. ...
	Definición 1.2. ...
	Teorema 1.3. ...
	Teorema 2.1. ...

Sin embargo, el comportamiento anterior puede modificarse con la opción `nocontnum`, la que al ser activada produce la siguiente salida:

	Teorema 1.1. ...
	Definición 1.1. ...
	Teorema 1.2. ...
	Teorema 2.1. ...

### Otros Comandos

Por último, existen comandos de letras en modo matemático. Cada letra mayúscula del abecedario tiene un comando asociado, el que imprimirá una letra en una fuente diferente (que depende de la letra). La fuente en que una letra se imprime ha sido elegida de forma arbitraria, intentando rescatar las que se usan con mayor frecuencia. Si se desea modificar la letra que imprime un comando basta con redefinirlo mediante ```\renewcommand{\<letra>}{<comando>}```.

## Créditos

Esta clase fue inicialmente desarrollada y mantenida por Nikolas Tapia M., alumno memorista del Departamento de Ingeniería Matemática de la Facultad de Ciencias Físicas y Matemáticas, Universidad de Chile. Luego fue mantenido por ADI - Área de Infotecnologías y actualmente por el Centro Tecnológico Ucampus. Luego fue actualizado por Aidan Hogan para armonizarla mejor con la pauta actual de la biblioteca y evitar problemas comunes con las entregas de memorias/tesis.

## Changelog
[23-09-2021] v.1.6.1
- Arreglar un bug con tener solo el título de memoria

[13-07-2021]
- Transferir el repo a la organización de DCCUchile y cambiar el nombre para destacar que se puede usar para tesis
- Actualizar algunos detalles en el README.md
- Agregando la palabra Apéndice/Appendix a la Tabla de Contenido

[09-07-2021] v1.6
- Quitando el template.tex y scripts de build.
- Redefiniendo la portada para seguir mejor la pauta de la biblioteca.
- Cambiando las definiciones para generar la portada, ofreciendo más opciones (doble titulación, cotutela, co-guías, etc.).
- Quitando páginas en blanco del inicio del documento. Quitando comandos redundantes de \cleardoublepage.
- Agregando el título y autor al meta-datos del PDF automáticamente.
- Renombrando el memoria.tex a main.tex para indicar que se puede usar para tesis (¿quizás se debe renombrar la clase en el futuro?).
- Actualizando el main.tex como un ejemplo que se puede adaptar (cambiando la codificación a utf8, quitando upright y otras opciones obsoletas, cambiando los argumentos de book, utilizando las nuevas definiciones para la portada, agregando números a la introducción y la conclusión, etc.).
- Renombrando los archivos para los capítulos.
- Agregando la opción `english` a la clase para cambiar el idioma al inglés
- Actualizando la documentación para quitar las instrucciones de instalación de la clase.

[11-05-2021]
- Upright desactivado por defecto

[24-09-2018]
- Bugfix: La comisión se separa con comas, corrijo esta documentación
- Texmaker reclama por imagen fcfm sin extensión y por la falta de natwidth/natheight

[10-04-2016]
- Se aceptan N-profesores guía
- Fix nombre "Tabla de Contenido"

[06-01-2015]
- Limpieza del código
- Movido a github del ADI

[21-06-2012] v1.3
- Se saca el package inputenc y fontenc de la definción de la clase, delegando la decisión al usuario.
- Corregidos problemas de formato con la numeración en el \frontmatter
- Cambiado el nombre del comando \opting a \carrera
- Cambiada la funcionalidad del comando \comision. Ahora acepta cada nombre como argumento separado.
- Agregados los entornos 'intro' y 'conclusion'
- Cambiada la opción por defecto openright por openany
- Comentado el codigo fuente
- Cambiada la definición de los entornos abstrac y thanks, ahora son más coherentes con el formato.
- Reescrito desde cero el archivo de muestra

[19-06-2012] v1.2
- Cambio de nombre de la clase de memoriadim a umemoria
- Arreglados problemas de compatibilidad
- Reducidas dependencias

[28-04-2012] v1.1
- Escudo de la Universidad en formato vectorizado se incluye junto con el package.

[11-04-2012] v1.0
- Primera versión
