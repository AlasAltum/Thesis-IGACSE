

# Arquitectura general:

Antes de explicar la arquitectura del programa en específico, es necesario explicar cómo se estructuran los programas hechos en Godot, pues esto justifica las decisiones de diseño tomadas durante el desarrollo de la aplicación.

## Arquitecutra de Godot:

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


Los tutoriales poseen una lógica más compleja y similar a los niveles. Están para aclimatar al usuario a la aplicación y prepararlo para los niveles siguientes, por lo que su estructura es similar. Este tipo de escenas se diferencia de los niveles jugables porque poseen una ventana de diálogo, que busca conectar la historia del videojuego con los elementos interactuables de este. Esto se explica más en el apartado de diseño de la aplicacación. [Agregar diagrama]



# Diseño de la aplicación

En este apartado de justifican las decisiones de diseño que explican por qué se decidió la temática de grafos, cuáles son los elementos interactivos y la ubicación y responsividad de estos. Wiley indica en su libro sobre diseño interactivo [Cita Wiley libro] que es relevante entender primero cuál es el problema que busca resolverse, qué usuarios se ven afectados por esto, qué características poseen y cómo podría solucionarse en base a prototipos.

En un inicio, el problema identificado se basó en una propuesta de tesis, basada en ofrecer visualización de estructuras de datos para el ramo Algoritmos y Estructuras de Datos de la Universidad de Chile [link propuestas de tesis].  

