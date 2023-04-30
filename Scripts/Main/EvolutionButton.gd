extends Button

func _ready():
	custom_minimum_size = Vector2(50, 50)
	position = Vector2(get_viewport_rect().size.x - custom_minimum_size.x - 10, 10)
	$EvolutionCount.position = Vector2(custom_minimum_size.x - 10, -10) 
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(1, 0, 0))
	style.set_border_width_all(0)
	style.set_corner_radius_all(10)

	$EvolutionCount.set("custom_styles/normal", style)
	$EvolutionCount.set("custom_styles/hover", style)
	$EvolutionCount.set("custom_styles/pressed", style)
	$EvolutionCount.set("custom_styles/focus", style)

func _process(delta):
	pass
