extends Panel

enum DrawerState {HIDDEN, VISIBLE}
var drawer_state = DrawerState.HIDDEN
var target_rect: Rect2
var hidden_rect: Rect2
var slide_duration: float = 0.2
var elapsed_time: float = 0

func _ready():
	custom_minimum_size = Vector2(200, get_viewport_rect().size.y)
	target_rect = Rect2(get_viewport_rect().size - custom_minimum_size, custom_minimum_size)
	hidden_rect = Rect2(Vector2(get_viewport_rect().size.x, 0), custom_minimum_size)
	global_position = hidden_rect.position
	update_drawer_style()

func _process(delta):
	if drawer_state == DrawerState.HIDDEN:
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

func show_drawer(queued_evolutions_count):
	if drawer_state != DrawerState.HIDDEN:
		return

	drawer_state = DrawerState.VISIBLE
	elapsed_time = 0
	$NoEvolutionsMessage.visible = queued_evolutions_count == 0

func update_drawer_style():
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0, 0, 0, 0.3))
	style.set_border_width_all(0)
	set("custom_styles/panel", style)

func _on_close_button_pressed():
	drawer_state = DrawerState.HIDDEN
	elapsed_time = 0
