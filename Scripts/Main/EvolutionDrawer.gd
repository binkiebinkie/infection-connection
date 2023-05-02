class_name EvolutionDrawer
extends Panel
@onready var player = get_node('../../Player')

enum DrawerState {HIDDEN, VISIBLE}
var drawer_state = DrawerState.HIDDEN
var target_rect: Rect2
var hidden_rect: Rect2
var slide_duration: float = 0.2
var elapsed_time: float = 0
var animating = false
var evolution_manager

func _init(_evolution_manager):
	evolution_manager = _evolution_manager

func _ready():
	custom_minimum_size = Vector2(400, get_viewport_rect().size.y)
	target_rect = Rect2(get_viewport_rect().size - custom_minimum_size, custom_minimum_size)
	hidden_rect = Rect2(Vector2(get_viewport_rect().size.x, 0), custom_minimum_size)
	global_position = hidden_rect.position
	update_drawer_style()

func _process(delta):
	if not animating:
		return

	elapsed_time += delta
	if elapsed_time > slide_duration:
		elapsed_time = slide_duration

	var t = elapsed_time / slide_duration
	if drawer_state == DrawerState.VISIBLE:
		global_position = hidden_rect.position.lerp(target_rect.position, t)
	else:
		global_position = target_rect.position.lerp(hidden_rect.position, t)

	if elapsed_time == slide_duration:
		drawer_state = DrawerState.HIDDEN
		animating = false

func show_drawer(queued_evolutions_count):
	if drawer_state != DrawerState.HIDDEN:
		return

	drawer_state = DrawerState.VISIBLE
	elapsed_time = 0
	animating = true
	$NoEvolutionsMessage.visible = queued_evolutions_count == 0

func update_drawer_style():
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0, 0, 0, 0.3))
	style.set_border_width_all(0)
	set("custom_styles/panel", style)

func _on_close_button_pressed():
	drawer_state = DrawerState.HIDDEN
	elapsed_time = 0
	animating = true

func update_evolution_options(queued_evolutions):
	while $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).queue_free()

	for option in queued_evolutions:
		var hbox = HBoxContainer.new()
		var texture_rect = TextureRect.new()
		texture_rect.texture = option.get_icon()
		hbox.add_child(texture_rect)
		$VBoxContainer.add_child(hbox)
		
		var label = Label.new()
		label.text = "%s (Lvl %d)" % [option.option_name, option.level]
		hbox.add_child(label)

		var option_button = Button.new()
		option_button.text = "Evolve"
		hbox.add_child(option_button)
		option_button.connect("pressed", Callable(self, "_on_option_button_pressed").bind(option))

func _on_option_button_pressed(option: EvolveOption):
	player.apply_evolve_option(option)
	var next_evolutions = evolution_manager.generate_evolve_options(player)
	update_evolution_options(next_evolutions)
	if next_evolutions.empty():
		_on_close_button_pressed()

func set_player(value):
	player = value
