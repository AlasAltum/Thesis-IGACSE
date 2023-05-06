shader_type canvas_item;

uniform vec4 assigned_color;
uniform vec4 WHITE = vec4(1.0, 1.0, 1.0, 0.2);
uniform float FREQ = 2.0;
uniform float highlight = 1.0;
uniform float amplitude = 0.1f;

void vertex()
{
	VERTEX *= (1.0 + highlight * amplitude * sin(TIME * FREQ));
}

void fragment()
{
	COLOR = texture(TEXTURE, UV); //read from texture
	COLOR *= assigned_color;
}