class_name ColorMap
extends Resource

# Taken from matplotlib
# https://matplotlib.org/stable/api/_as_gen/matplotlib.colors.Colormap.html#matplotlib.colors.Colormap
# Python code to generate this color map

"""
from matplotlib import cm

cividis = cm.get_cmap('cividis', 14)
list(list(element) for element in cividis.colors)
"""

const civiridis = [
	[0.0, 0.135112, 0.304751, 1.0],
	[0.0, 0.186915, 0.435532, 1.0],
	[0.148638, 0.239724, 0.430752, 1.0],
	[0.243485, 0.294274, 0.423014, 1.0],
	[0.316941, 0.345842, 0.425512, 1.0],
	[0.387705, 0.400694, 0.437305, 1.0],
	[0.455072, 0.456718, 0.458976, 1.0],
	[0.521643, 0.511367, 0.472639, 1.0],
	[0.597469, 0.570718, 0.465821, 1.0],
	[0.675981, 0.632468, 0.446736, 1.0],
	[0.752886, 0.693766, 0.416472, 1.0],
	[0.836429, 0.761483, 0.368747, 1.0],
	[0.923279, 0.832822, 0.295244, 1.0],
	[0.995737, 0.909344, 0.217772, 1.0],
]
# 167.1
# 77.1
# -12.1

static func array_to_color(array4: Array) -> Color:
	return Color(array4[0], array4[1], array4[2], array4[3])


static func generate_n_colors(num_nodes: int) -> Array:
	var colors: Array = []
	var jump_size : int = civiridis.size() / num_nodes
	for index in range(0, civiridis.size(), jump_size):
		colors.append(array_to_color(civiridis[index]))
	return colors

