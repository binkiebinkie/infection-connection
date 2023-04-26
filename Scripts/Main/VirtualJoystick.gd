extends Node

var max_distance: float = 100.0
var is_pressed: bool = false
var touch_id: int = -1
var touch_start_position: Vector2
var mouse_position: Vector2

func _input(event: InputEvent):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var pressed = false
		if event is InputEventScreenTouch:
			pressed = event.pressed
		else:
			pressed = event.pressed and event.button_index == MOUSE_BUTTON_LEFT

		if pressed and is_pressed == false and event.position.x < get_viewport().size.x / 2:
			is_pressed = true
			touch_id = event.index if event is InputEventScreenTouch else -1
			touch_start_position = event.position
		elif not pressed and ((event is InputEventScreenTouch and event.index == touch_id) or event is InputEventMouseButton):
			is_pressed = false
			touch_id = -1
	elif (event is InputEventScreenDrag and is_pressed and event.index == touch_id) or (event is InputEventMouseMotion and is_pressed and touch_id == -1):
		touch_start_position += event.relative
		touch_start_position = touch_start_position.limit_length(max_distance)

func get_input_direction() -> Vector2:
	if not is_pressed:
		return Vector2.ZERO
	var direction = (mouse_position - touch_start_position)
	return direction.normalized()
