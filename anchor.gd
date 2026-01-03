extends Node2D

@onready var cursor_position;
var controller = Input.get_connected_joypads()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if controller.size() == 1:
		var move = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		)
		cursor_position = move * 5 
		var angle = position.angle_to_point(cursor_position)
		rotation = angle

	if controller.size() == 0:
		cursor_position = get_global_mouse_position()
		var angle = global_position.angle_to_point(cursor_position)
		rotation = angle
