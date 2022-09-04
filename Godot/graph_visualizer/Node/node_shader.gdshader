shader_type canvas_item;

uniform vec4 assigned_color;


void fragment()
{
	COLOR = texture(TEXTURE, UV); //read from texture
	COLOR *= assigned_color; //set blue channel to 1.0
}