

# Arquitectura general:

Antes de explicar la arquitectura del programa en específico, es necesario explicar cómo se estructuran los programas hechos en Godot, pues esto justifica las decisiones de diseño tomadas durante el desarrollo de la aplicación.

## Arquitectura de una aplicación en Godot:

Una aplicación en Godot se construye en base a escenas. Una escena es un conjunto de objetos instanciados al mismo tiempo. Un programa creado en este motor se compone de escenas, que típicamente serán los niveles en un juego. Las escenas tienen un grafo de escena compuesto por uno o más nodos.

Los nodos en Godot son la unidad básica de construcción del programa. Un nodo puede representar un botón, una textura, un reproductor de sonido, áreas de colisión, entre otros. Para armar un personaje que funciona con varios niveles de lógica, tales como: habilidades, movimiento o colisiones, se deben componer más nodos.
Aplicado a la aplicación de la que se trata esta tesis, un GraphNode posee: un área de colisión, un nodo de sprites (texturas) y otra parte de animaciones. [Mostrar imagen...]

La estructura de un grafo de escena resulta conveniente al momento de desarrollar videojuegos, porque basta mover el nodo padre que representa al personaje (en este caso al Grafo de Escena) para mover al mismo tiempo: colisiones, sonidos y texturas asociadas al personaje. En cambio, cuando se trabaja a bajo nivel para lograr estos efectos, como en PyGame, donde se emplea OpenGL, se debe trabajar con cada nivel de representación de un objeto. A modo de ejemplo, si se quiere mover a un personaje con estas librerías, se debe mover la textura y las colisiones por separado en el código, aumentando los costos de desarrollo. La filosofía de Godot es abstraer esa lógica, permitiendo que el desarrollo se concentre más en la lógica propia de la aplicación [Necesitaré citar esto?].


## Arquitectura específica de la aplicación:

La aplicación se desenvuelve en diferentes fases, donde se pueden identificar 3 tipos de escenas:

1) Menúes
2) Tutoriales
3) Niveles jugables


En cada fase, los módulos son distintos. Cada nivel, menú o tutorial representa una escena.

Un nivel con menú es como se indica: [Agregar diagrama]

Los menúes se basan principalmente en nodos de control, que se usan típicamente para interfaces gráficas. En este caso, los menúes son únicamente botones que ejecutan códigos según su descripción. 

Los tutoriales poseen una lógica más compleja y similar a los niveles. Su rol es aclimatar al usuario a la aplicación y prepararlo para los niveles siguientes, por lo que su estructura es similar a los niveles jugables. Este tipo de escenas se diferencia de las esecenas finales porque poseen una ventana de diálogo, la cual busca conectar la historia del videojuego con los elementos interactuables de este. Esto se explica más en el apartado de diseño de la aplicacación. [Agregar diagrama]

Cada tutorial posee un script específico, que verifica constantemente si el jugador completó los pasos necesarios para pasar al siguiente nivel o tutorial según corresponda. Al inicio de cada tutorial, se despliega el diálogo que conecta la historia del juego con lo que se debe hacer en cada paso. Cuando se cierra el diálogo, se activan las acciones del jugador.

Respecto a los niveles, aquí existen diversos elementos que hay que destacar. Entre estos, se encuentran: El código, las variables, la variable seleccionada y la ventana de juego. El diagrama [PONER REFERENCIA AL DIAGRAMA] presenta cómo se relacionan estos elementos.

Respecto al código, este se comprime en un nodo de la clase CodeContainer. Este objeto se encarga de recibir el input del jugador para avanzar en el código. Si las instrucciones para avanzar en el código son correctas, el usuario pasa a la siguiente instrucción, desbloqueando una acción ejecutable. La clase CodeContainer posee un arreglo de objetos CodeLine llamado code_lines. La clase CodeLine contienen toda la lógica de una única línea de código. Entre sus funciones, se encuentran: darle énfasis a la línea de código actual, darle feedback al usuario cuando la instrucción de la línea se completó correctamente y verificar constantemente si la instrucción de línea se ha completado correctamente.

Cada CodeLine posee un script que se puede indicar desde el editor de Godot. Este script debe heredar de la clase EffectCheck, la cual actúa como interfaz. Cada script que implemente la clase EffectCheck debe definir métodos para cuando: 1) El puntero de instrucción llega a la línea del script. 2) Para verificar que la instrucción actual ha sido realizada correctamente. 3) Si corresponde, efectos colaterales de la instrucción. Esto ocurre en los ciclos for, donde se mueve permanentemente una variable índice utilizada para avanzar por los ciclos. También se utiliza para la creación de variables.

En el panel de abajo se encuentran dos clases: DebugBlock y ADTShower. El primero se encarga de mostrar las variables instanciadas, su nombre y su valor actual. Contiene la lógica para agregar, modificar o eliminar alguna variable.  Cada vez que se pasa por un ciclo for o se declara una variable, este modifica sus variables internas. Respecto al ADTShower, este se encarga de mostrar la variable seleccionada actualmente en el DebugBlock. La idea detrás del DebugBlock es permitir arrastrar nodos a la cola o la pila según el algoritmo que se esté enseñando, BFS o DFS, respectivamente.

Se observa




## Diseño de la aplicación

En este apartado se justifican las decisiones de diseño que explican por qué se decidió la temática de grafos, cuáles son los elementos interactivos y la ubicación y responsividad de estos. Según Wiley en su libro sobre diseño interactivo [Cita Wiley libro], es relevante entender primero cuál es el problema que busca resolverse, qué usuarios se ven afectados por esto, qué características poseen y cómo podría solucionarse en base a prototipos.

Inicialmente, el problema identificado se basó en una propuesta de tesis que buscaba ofrecer visualización de estructuras de datos para el ramo Algoritmos y Estructuras de Datos de la Universidad de Chile [link propuestas de tesis]. Posteriormente, se realizaron análisis bibliográficos para comprender los problemas que enfrentan los estudiantes de Ciencias de la Computación al aprender algoritmos y estructuras de datos. Por ejemplo, en [https://dl.acm.org/doi/pdf/10.1145/3230977.3231005] se menciona que los estudiantes a menudo creen entender los contenidos, pero tienen conceptos erróneos sin darse cuenta.


En el trabajo de [https://dl.acm.org/doi/pdf/10.1145/3230977.3231005, W. Paul y J. Vahrenhold. Hunting high and low: Instruments to detect misconceptions related to algorithms and data structures. En Proceedings of the 44th ACM Technical Symposium on Computer Science Education, páginas 29-34, 2013, O. Seppälä, L. Malmi y A. Korhonen. Observations on student misconceptions - a case study of the Build-Heap Algorithm. Computer Science Education, 16(3):241-255, 2006] se mencionan algunos ejemplos de malos entendidos por parte de los estudiantes, como errores al comprender los heaps y las formas en que pueden representarse o construirse. Además, se revisaron canales educativos de YouTube como 3Blue1Brown [https://www.youtube.com/@3blue1brown], donde el propietario del canal, Grant Sanderson, habla repetidamente sobre cómo las visualizaciones ayudan a comprender la abstracción matemática subyacente.

Se observó que los estudiantes enfrentan dificultades para comprender el contenido abstracto y su lógica subyacente, incluso pueden resolver un problema de informática correctamente con estos conceptos erróneos. Por estas razones, surge la hipótesis de que una aplicación de visualización, donde se muestren constantemente los objetos relacionados con un algoritmo y se observe cómo cambian a lo largo del procedimiento, permite desmantelar conceptos erróneos y aterrizar los contenidos para los estudiantes de algoritmos y estructuras de datos.

El autor de este trabajo también ha desempeñado labores como profesor auxiliar y ayudante en más de 6 ocasiones en la universidad y considera que un problema común es que los estudiantes creen haber entendido un algoritmo después de ver el código y ver cómo un profesor resuelve un algoritmo paso a paso frente a la pizarra, pero cuando se les pide recrear los mismos pasos, no son capaces de hacerlo. Por esta razón, una visualización no es suficiente y se requiere una forma de aprendizaje activa, donde el estudiante tenga que realizar los pasos para asegurarse de que no solo los comprendió, sino que también los ejecutó y será capaz de replicarlos posteriormente.

Con estos antecedentes, se decidió crear un videojuego educativo para tener interactividad y asegurarse de que el usuario se vea incentivado a probar la aplicación y luego replicar los pasos.

Una vez identificados los problemas, los usuarios objetivo y una posible solución, el siguiente paso consistió en buscar inspiración y prototipar. Dado que se decidió crear un videojuego educativo, la inspiración y los prototipos deben provenir de aplicaciones similares. Algunas de ellas son:

Runescape, un juego de rol multijugador en línea. Se puede observar que posee una ventana de chat con mucho texto. A la derecha se encuentra un panel interactivo para elegir qué herramientas se utilizarán en el videojuego. Este panel también proporciona información relevante sobre el estado del personaje. [imagen]

Tibia, similar a Runescape. También posee una ventana de chat, y a la derecha posee un panel interactivo. [imagen]

World of Warcraft, similar a los anteriores. A la derecha presenta las misiones por realizar, lo que indica al jugador qué debe hacer, pero no es necesario que el usuario esté constantemente prestando atención. Sin embargo, el panel de habilidades se encuentra en la parte inferior y requiere la atención constante del jugador.  [https://images.squarespace-cdn.com/content/v1/5b1562924cde7ad879d8107c/1532619754919-YA8MBAPE3JUB2ZP86DQS/default.jpg?format=1500w]

Warcraft III. Se puede observar que en la parte inferior hay un gran panel que muestra mucha información sobre el estado actual de la partida, así como las habilidades del jugador. Se puede dejar el cursor sobre una habilidad para mostrar qué efecto tiene.  [https://s2editor-guides.readthedocs.io/New_Tutorials/07_Lessons/resources/087_Create_an_Aura_Ability1.png, https://s2editor-guides.readthedocs.io/New_Tutorials/07_Lessons/087_Create_an_Aura_Ability/]

7 Billion Humans [https://images.gog-statics.com/10607b4c491900ffeab0f9967a750864c7027088ac93d75c274b00baee284638_product_card_v2_mobile_slider_639.jpg]
Un videojuego basado que se trata de resolver puzzles basado en un lenguaje de programación entregado por el juego.

Debugger de VSCode. No es un videojuego, sino un editor enriquecido de texto para trabajar con código, aunque con extensiones puede funcionar como un entorno de desarrollo integrado (IDE). De aquí se extrajeron ideas como la visualización en tiempo real de nombres y valores de variables. Estas modificaciones se muestran línea por línea, lo que permite comprender mejor cómo funciona un programa. [imagen]

CodeCombat. Un videojuego tipo puzzle basado en programación. El jugador debe escribir todo el código que le permitirá superar un nivel. Este código corresponde a las instrucciones que recibe el personaje y que ejecuta cuando inicia el nivel. Si las instrucciones fueron correctas, el personaje superará los obstáculos y podrá pasar al siguiente nivel. [CodeCombat, https://www.linuxadictos.com/wp-content/uploads/codecombat.jpg.webp]

Considerando los antecedentes anteriores, se decidió crear una visualización animada e interactiva sobre algoritmos y estructuras de datos. Los elementos de gamificación aumentarían la motivación de los estudiantes. Respecto a las temáticas vistas, se observó que muchas estructuras de datos mostradas eran lineales y permitían poca innovación en diseño, por ejemplo, listas enlazadas, diccionarios, arreglos, colas o conjuntos. Resultaba más gamificable y daba más espacio de a la creatividad el trabajar con grafos. Además, se revisó literatura científica al respecto, y se encontraron menos recursos relacionados a grafos.

Se determinó que la aplicación debe mostrar cada paso del algoritmo con retroalimentación visual al usuario, además de mostrar qué sucede con las variables en cada paso. El programa debe requerir que el usuario piense en algunos pasos, de modo de evitar la mecanización y facilitar el entendimiento del algoritmo como una sucesión de pasos. En este caso, la aplicación espera enseñar sobre un contenido ya determinado, por lo que no se espera que el estudiante programe, sino que ejecute las instrucciones de los algoritmos a enseñar. Los objetivos del curso algoritmos y estructuras de datos también se alinean de esa forma, donde se pone más énfasis en entender las estructuras y algoritmos, la programación, en cambio, está en uno solo de los objetivos especificados [Programa del curso CC3001, Algoritmos y Estructuras de Datos Universidad de Chile. https://ucampus.uchile.cl/m/fcfm_catalogo/programa?bajar=1&id=68645].

Tomando en consideración todos los elementos anteriores, se construyó un primer prototipo hecho completamente en Godot. Es esperable realizar un primer acercamiento en papel, pero Godot es un motor de juegos que permite la experimentación de forma muy concisa. Estos primeros prototipos recibieron retroalimentación principalmente por parte del curso Trabajo de Tesis I (CC7970) [Mostrar imagen del primer prototipo]. Aquí se recibía feedback con conocimiento era experto, pues el curso se componía de gente que estaba en el postgrado de Ciencias de la Computación.

El costo de desarrollo de nuevas características resultaba más alto que para una aplicación de consola común. Cada elemento nuevo que se agregaba requería validación en distintos niveles: Primero, esta debía ser correcta en relación al algoritmo que se buscaba enseñar y tener sentido dentro del contexto; Segundo, debía buscarse una representación a nivel visual y auditivo de la acción ejecutada por cada jugador; Tercero, cada acción nueva que se introducía para un jugador, agregaba más grados de libertad al programa, incrementando su incertidumbre y abriendo paso a muchos bugs. Por estas razones, se decidió a limitar la cantidad de algoritmos que el programa enseñaría a 4: Breadth First Search (BFS), Depth First Search (DFS), Kruskal y Prim. 

La idea detrás del primer prototipo es mostrar una ventana principal donde se observa la ejecución del algoritmo en tiempo real, similar a lo que realiza un profesor cuando muestra los efectos de las instrucciones paso a paso. El usuario debe interactuar con esta pizarra, para asegurarse de que replique los pasos por su cuenta. Otro elemento importante es el código a un costado de la pantalla, el cual representa las instrucciones que el usuario debe seguir para ganar. Existe un puntero que indica la instrucción actual en la que está el jugador, tal como lo hace el Debugger de VSCode. Se avanza en el código a medida que se completan los pasos del código a través de la interacción con la pizarra.

Con este prototipo aparecieron algunas quejas y sugerencias recurrentes. Entre ellas, que existía poca retroalimentación del estado actual de la aplicación. Por ejemplo, en más de una ocasión aparecieron comentarios como: ¿Qué pasa con el nodo t? ¿Cuál es el nodo t?. Por esta razón, apoyándose aún más en el debugger de VSCode, se hizo un panel abajo que contiene las variables, sus nombres y sus valores. [Mostrar imagen prototipo]

Posteriormente, para sumergir al usuario aún más en el desafío de terminar el nivel, se agregaron elementos como un panel de creación de estructuras de datos abstractas como colas, pilas, arreglos y conjuntos. Este elemento se inspiró a partir de programas como Paint o Gimp, donde existen paneles con diversas herramientas [Agregar imágnees de Paint y Gimp]. Se mostró el programa con estos cambios a seis usuarios, esta vez sin guía alguna. Tres de ellos reportaron que no sabían qué hacer en diversos puntos de la aplicación. Dialogando con estos usuarios, la conclusión a la que se llegó es que faltaba más guía por parte del programa, pues el código no era suficientes para saber qué hacer para llegar al final de cada nivel.

Dado el problema de falta de feedback que experimentaban los usuarios, se decidió agregar un apartado de instrucciones en texto, que le indican al usuario exactamente qué hacer. [Mostrar imagen]. Una vez arreglados los bugs reportados y terminada la navegación que permitía pasar por todos los niveles de inicio a final, se creó este apartado de hints similar a como ocurre en títulos como la saga GTA [imagen instrucciones GTA https://static.wikia.nocookie.net/gtawiki/images/0/07/BlowUpII-GTAO.jpg/revision/latest?cb=20140804082259 recueprado de https://gta.fandom.com/wiki/Blow_Up_II]. Nuevamente, se realizó otra iteración de retroalimentación con usuarios que ya habían egresado de ingeniería civil en computación o eléctrica. Estos usuarios tenían conocimiento de videojuegos. El tamaño de esta muestra fue de 4. 

Surgió el feedback de que no no es bueno tener tanto texto en una aplicaicón interactiva. Dos usuarios se pusieron el desafío de no leer los hints. Uno de ellos reportó tener amplio conocimiento de videojuegos e incluso haber publicado un título. Este usuario indicó que es ideal evitar el texto. Que las instrucciones tales como clickear cierto nodo deberían limitarse a la animación de un mouse haciendo click en cierto nodo. Todos los usuarios mostraron dificultades para leer instrucciones o dijeron que tenían problemas para entender las instrucciones en una primera ocasión, así que se estas se descartaron y se reemplazaron por feedback visual.

[Ahí estoy y esto debo avanzar]