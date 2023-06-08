

# Arquitectura general:

Antes de explicar la arquitectura del programa en específico, es necesario explicar cómo se estructuran los programas hechos en Godot, pues esto justifica las decisiones de diseño tomadas durante el desarrollo de la aplicación.

## Arquitectura de una aplicación en Godot:

Una aplicación en Godot se construye en base a escenas. Una escena es un conjunto de objetos instanciados al mismo tiempo. Un programa creado en este motor se compone de escenas, que típicamente serán los niveles en un juego. Las escenas tienen un grafo de escena compuesto por uno o más nodos.

Los nodos en Godot son la unidad básica de construcción del programa. Un nodo puede representar un botón, una textura, un reproductor de sonido, áreas de colisión, entre otros. Para armar un personaje que funciona con varios niveles de lógica, tales como: habilidades, movimiento o colisiones, se deben componer más nodos.
En el caso de la aplicación que se aborda en esta tesis, se crea la clase GraphNode, un nodo que incluye un área de colisión, un nodo de sprites (texturas) y una sección adicional para las animaciones. [Mostrar imagen...] 
La estructura del grafo de escena resulta conveniente en el desarrollo de videojuegos, porque basta mover el nodo padre que representa al personaje (en este caso, el GraphNode), para mover simultáneamente las colisiones, los sonidos y texturas asociadas al personaje. Esto facilita la manipulación de los elementos relacionados.

En contraste, cuando se trabaja a un nivel más bajo utilizando bibliotecas como PyGame, que utiliza OpenGL, es necesario abordar cada nivel de representación de un objeto por separado. Por ejemplo, si se desea mover a un personaje con estas bibliotecas, se debe gestionar la textura y las colisiones de manera individual y separada en el código, lo que resulta en un aumento de los costos y la complejidad del desarrollo. [¿Es necesario citar esto?].


## Arquitectura específica de la aplicación:

La aplicación se desarrolla en diferentes fases, donde se pueden identificar 3 tipos de escenas: menús, tutoriales y niveles jugables. En cada fase, se utilizan módulos distintos, y cada nivel, menú o tutorial representa una escena.


Un nivel con menú se compone de la siguiente manera: [Agregar diagrama]

Los menús se basan principalmente en nodos de control, que se utilizan típicamente para interfaces gráficas. En este caso, los menús consisten únicamente en botones que ejecutan códigos según su descripción.

Los tutoriales tienen una lógica más compleja y son similares a los niveles. Su objetivo es familiarizar al usuario con la aplicación y prepararlo para los niveles siguientes, por lo que su estructura es similar a la de los niveles jugables. La diferencia con las escenas finales es que los tutoriales incluyen una ventana de diálogo que busca conectar la historia del videojuego con los elementos interactivos. Esto se explica con más detalle en la sección de diseño de la aplicación. [Agregar diagrama]


Diseño de la aplicación