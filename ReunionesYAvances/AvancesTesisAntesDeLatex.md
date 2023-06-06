

# Arquitectura general:

Antes de explicar la arquitectura del programa en específico, es necesario explicar cómo se estructuran los programas hechos en Godot, pues esto justifica las decisiones de diseño tomadas durante el desarrollo de la aplicación.

## Arquitectura de Godot:

Una aplicación en Godot se construye en base a escenas. Una escena es un conjunto de objetos instanciados al mismo tiempo. Un programa creado en este motor se compone de escenas, que típicamente serán los niveles en un juego. Las escenas tienen un grafo de escena compuesto por uno o más nodos.
Los nodos en Godot son la unidad básica de construcción del programa. Un nodo puede representar un botón, una textura, un reproductor de sonido, áreas de colisión, entre otros. Para armar un personaje que funciona con varios niveles de lógica, tales como: habilidades, movimiento o colisiones, se deben componer más nodos.
Aplicado a la aplicación de la que se trata esta tesis, un GraphNode posee: un área de colisión, un nodo de sprites (texturas) y otra parte de animaciones. [Mostrar imagen...]

La estructura de un grafo de escena resulta conveniente al momento de desarrollar videojuegos, porque basta mover el nodo padre que representa al personaje (en este caso al Grafo de Escena) para mover al mismo tiempo: colisiones, sonidos y texturas asociadas al personaje. En cambio, cuando se trabaja a bajo nivel para lograr estos efectos, como en PyGame, donde se emplea OpenGL, se debe trabajar con cada nivel de representación de un objeto. A modo de ejemplo, si se quiere mover a un personaje con estas librerías, se debe mover la textura y las colisiones por separado en el código, aumentando los costos de desarrollo. La filosofía de Godot es abstraer esa lógica, permitiendo que el desarrollo se concentre más en la lógica propia de la aplicación [Necesitaré citar esto?].


# Arquitectura de la aplicación:

La aplicación se desenvuelve en diferentes fases, donde se pueden identificar 3 tipos de escenas:

1) Menúes
2) Tutoriales
3) Niveles jugables


En cada fase, los módulos son distintos. Cada nivel, menú o tutorial representa una escena.

Un nivel con menú es como se indica: [Agregar diagrama]

Los menúes se basan principalmente en nodos de control, que se usan típicamente para interfaces gráficas. En este caso, los menúes son únicamente botones que ejecutan códigos según su descripción. 

Los tutoriales poseen una lógica más compleja y similar a los niveles. Su rol es aclimatar al usuario a la aplicación y prepararlo para los niveles siguientes, por lo que su estructura es similar a los niveles jugables. Este tipo de escenas se diferencia de las esecenas finales porque poseen una ventana de diálogo, la cual busca conectar la historia del videojuego con los elementos interactuables de este. Esto se explica más en el apartado de diseño de la aplicacación. [Agregar diagrama]



## Diseño de la aplicación

En este apartado de justifican las decisiones de diseño que explican por qué se decidió la temática de grafos, cuáles son los elementos interactivos y la ubicación y responsividad de estos. Wiley indica en su libro sobre diseño interactivo [Cita Wiley libro] que es relevante entender primero cuál es el problema que busca resolverse, qué usuarios se ven afectados por esto, qué características poseen y cómo podría solucionarse en base a prototipos.

En un inicio, el problema identificado se basó en una propuesta de tesis, basada en ofrecer visualización de estructuras de datos para el ramo Algoritmos y Estructuras de Datos de la Universidad de Chile [link propuestas de tesis]. Posteriormente, se hicieron algunos análisis bibliográficos para entender cuáles son los problemas que aquejan a los estudiantes de ciencias de la computación cuando se introducen a los algoritmos y estructuras de datos. Por ejemplo, en [https://dl.acm.org/doi/pdf/10.1145/3230977.3231005] se menciona que muchas veces los estudiantes de algoritmos y estructuras de datos creen entender los contenidos, pero que tienen conceptos erróneos sin percatarse de ello.

Por mencionar algunos ejemplos de malos entendidos por parte del estudiantado, se mencionan errores al comprender los heaps, heaps, incluso las formas en que los heaps pueden representarse o construirse [https://dl.acm.org/doi/pdf/10.1145/3230977.3231005, W. Paul and J. Vahrenhold. Hunting high and low: Instruments to detect misconceptions related to algorithms and data structures. In Proceedings of the 44th
ACM Technical Symposium on Computer Science Education, pages 29–34, 2013, 
O. Seppälä, L. Malmi, and A. Korhonen. Observations on student misconceptions— a case study of the Build-Heap Algorithm. Computer Science Education, 16(3):241–
255, 2006]. Por otra parte, se revisaron canales de Youtube educativos como 3Blue1Brown [https://www.youtube.com/@3blue1brown], donde el dueño del canal, Grant Sanderson, quien habla en repetidas ocasiones de cómo las visualizaciones ayudan a entender la abstracción matemática subyacente. 

Se observa que los estudiantes se encuentran con dificultades en la comprensión del contenido abstracto y su lógica subyacente. Es posible incluso resolver un problema de informática correctamente con estos conceptos erróneos. Por estas razones, surge la hipótesis de que una aplicación de visualización, donde se visualicen constantemente los objetos relacionados con un algoritmo y se observe cómo cambian a lo largo del procedimiento, permite derribar conceptos erróneos y aterrizar los contenidos para los estudiantes de algoritmos y estructuras de datos.

El autor del presente trabajo también realizó labores como profesor auxiliar y ayudante en más de 6 ocasiones en la universidad, y piensa que un problema común es que los estudiantes creen haber entendido un algoritmo después de ver el código y ver cómo un profesor resuelve un algoritmo paso a paso frente a la pizarra, pero cuando se les pide recrear los mismos pasos, no son capaces de hacerlo. Es por esto que una visualización no basta y se requiere una forma de aprendizaje activa, donde el estudiante tenga que realizar los pasos para asegurarse de que no solo los comprendió, sino que también los realizó y de que será capaz de replicarlos posteriormente. 
Con estos antecedentes, se decidió hacer un videojuego educativo, para tener interactividad y asegurarse de que el usuario se vea incentivado a probar la aplicación para así poder replicar los pasos con posterioridad.

Una vez identificados los problemas, los usuarios objetivo y una posible solución, el siguiente paso consistió en buscar inspiración y prototipar. Como se decidió crear un videojuego educativo, la inspiración y los prototipos deben venir de aplicaciones similares. Entre ellas, se encuentran:

Runescape, un juego de rol multijugador en línea. Podemos observar que abajo posee una ventana de chat con mucho texto. A la derecha se encuentra un panel interactivo para elegir qué herramientas se utilizarán en el videojuego. Este panel también entrega información relevante sobre el estado del personaje. [imagen]

Tibia, similar a Runescape. También posee una ventana de chat, y a la derecha posee un panel interactivo. [imagen]

World of Warcraft, similar a los anteriores. A la derecha presenta las misiones por realizar, por lo que le indican al jugador qué debe hacer, pero no es necesario que el usuario esté dando su atención constantemente. Sin embargo, el panel de habilidades se encuentra abajo y este sí requiere de la atención constante del jugador. [https://images.squarespace-cdn.com/content/v1/5b1562924cde7ad879d8107c/1532619754919-YA8MBAPE3JUB2ZP86DQS/default.jpg?format=1500w]

Warcraft III. Se observa que abajo hay un gran panel donde existe mucha información del estado actual de la partida, así como las habilidades del jugador. Se puede dejar el mouse sobre una habilidad para mostrar qué efecto tiene una habilidad. [https://s2editor-guides.readthedocs.io/New_Tutorials/07_Lessons/resources/087_Create_an_Aura_Ability1.png, https://s2editor-guides.readthedocs.io/New_Tutorials/07_Lessons/087_Create_an_Aura_Ability/]

7 Billion Humans [https://images.gog-statics.com/10607b4c491900ffeab0f9967a750864c7027088ac93d75c274b00baee284638_product_card_v2_mobile_slider_639.jpg]
Un videojuego basado que se trata de resolver puzzles basado en un lenguaje de programación entregado por el juego.

Debugger de VSCode. No es un videojuego, sino un editor enriquecido de texto para trabajar con código, aunque con extensiones puede funcionar como un IDE (Integrated Development Environment). De aquí se extrajeron las ideas de que se pueden ver en tiempo reales los nombres y valores de las variables, así como se puede ver en tiempo real cuando cambian. Estas modificaciones se observan línea a línea, lo que permite comprender mejor cómo funciona un programa.  [imagen]

CodeCombat. Un videojuego tipo puzzle basado en programación. El jugador debe escribir todo el código que le permitirá superar un nivel. Este código corresponde a las instrucciones que recibe el personaje y que ejecuta cuando inicia el nivel. Si las instrucciones fueron correctas, el personaje superará los obstáculos y podrá pasar al siguiente nivel. [CodeCombat, https://www.linuxadictos.com/wp-content/uploads/codecombat.jpg.webp]

Considerando los antecedentes anteriores, se decidió crear una visualización animada e interactiva sobre algoritmos y estructuras de datos. Los elementos de gamificación aumentarían la motivación de los estudiantes. Respecto a las temáticas vistas, se observó que muchas estructuras de datos mostradas eran lineales y permitían poca innovación en diseño, por ejemplo, listas enlazadas, diccionarios, arreglos, colas o conjuntos. Resultaba más gamificable y daba más espacio de a la creatividad el trabajar con grafos. Además, se revisó literatura científica al respecto, y se encontraron menos recursos relacionados a grafos.

Se determinó que la aplicación debe mostrar cada paso del algoritmo con retroalimentación visual al usuario, además de mostrar qué sucede con las variables en cada paso. El programa debe requerir que el usuario piense en algunos pasos, de modo de evitar la mecanización y facilitar el entendimiento del algoritmo como una sucesión de pasos. En este caso, la aplicación espera enseñar sobre un contenido ya determinado, por lo que no se espera que el estudiante programe, sino que ejecute las instrucciones de los algoritmos a enseñar. Los objetivos del curso algoritmos y estructuras de datos también se alinean de esa forma, donde se pone más énfasis en entender las estructuras y algoritmos, la programación, en cambio, está en uno solo de los objetivos especificados [Programa del curso CC3001, Algoritmos y Estructuras de Datos Universidad de Chile. https://ucampus.uchile.cl/m/fcfm_catalogo/programa?bajar=1&id=68645].

De esta manera, se decidió por el primer prototipo, hecho completamente en Godot. Es esperable realizar un primer acercamiento en papel, pero Godot es un motor de juegos que permite la experimentación de forma muy concisa. Estos primeros prototipos recibieron retroalimentación principalmente por parte del curso Trabajo de Tesis I (CC7970) [Mostrar imagen del primer prototipo]. Aquí se recibía feedback con conocimiento era experto, pues el curso se componía de gente que estaba en el postgrado de Ciencias de la Computación.


