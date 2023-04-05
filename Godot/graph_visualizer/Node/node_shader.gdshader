shader_type canvas_item;

uniform vec4 assigned_color;
uniform vec4 WHITE = vec4(1.0, 1.0, 1.0, 0.2);
uniform float FREQ = 2.0;
uniform float highlight = 1.0;


void vertex()
{
	VERTEX *= (1.0 + highlight * 0.2 * sin(TIME * FREQ));
}

void fragment()
{
	COLOR = texture(TEXTURE, UV); //read from texture
	COLOR *= assigned_color; //set blue channel to 1.0
}