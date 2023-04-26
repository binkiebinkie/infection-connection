extends Button

func _ready():
	custom_minimum_size = Vector2(50, 50)
	position = Vector2(get_viewport_rect().size.x - custom_minimum_size.x - 10, 10)
	
	# Style and position the EvolutionCount label
	#$EvolutionCount.min_size = Vector2(20, 20)  # Set a minimum size
	$EvolutionCount.position = Vector2(custom_minimum_size.x - 10, -10)  # Position it to the top right of the button
	#$EvolutionCount.add_color_override("font_color", Color(1, 1, 1))  # Set the text color to white

	# Create a StyleBoxFlat for the background
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(1, 0, 0))  # Set the background color to red
	style.set_border_width_all(0)  # Remove the border
	style.set_corner_radius_all(10)  # Set the corner radius for a rounded appearance
	
	# Apply the style to the EvolutionCount label
	$EvolutionCount.set("custom_styles/normal", style)
	$EvolutionCount.set("custom_styles/hover", style)
	$EvolutionCount.set("custom_styles/pressed", style)
	$EvolutionCount.set("custom_styles/focus", style)

func _process(delta):
	pass
