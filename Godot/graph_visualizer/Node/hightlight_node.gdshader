shader_type canvas_item;
// This shader is not being used anymore
// but it is a template for a highlight shader
// Where a node is changing its size and color

uniform vec4 BLACK = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 WHITE = vec4(1.0, 1.0, 1.0, 0.2);
uniform float FREQ = 2.0;

void vertex()
{
	VERTEX *= (1.0 + 0.2 * sin(TIME * FREQ));
}

void fragment()
{
    vec4 curr_color = texture(TEXTURE, UV); // Get current color of pixel
	float t = sin(TIME * FREQ);
	COLOR = mix(curr_color, WHITE, t * t) * curr_color;	
}
