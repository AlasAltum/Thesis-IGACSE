class_name ColorInterpolator
extends Resource

# Our idea is to generate ranges of colors
# So we generate a line with it of length
# 256 * 256 * 256 => 16,777,216 total colors
# Then we separate this values in num_colors parts
# Each part will represent a Color

const MAX_INT = 16_777_216

# We have bit masks to generate a Color from a single int
const RED_MASK = 255  << 16
const GREEN_MASK = 255  << 8
const BLUE_MASK = 255 << 0

static func get_color_from_int(input_int: int) -> Color:
	assert (input_int <= 16_777_216)
	return Color (
		(input_int & RED_MASK) >> 16, 
		(input_int & GREEN_MASK) >> 8,
		(input_int & BLUE_MASK) >> 0
	)


static func gen_range_of_colors(num_colors: int) -> Array:
	var ret = []
	var jump_interval = MAX_INT / num_colors
	for i in range(num_colors):
		ret.append(jump_interval * i)

	return ret
	

