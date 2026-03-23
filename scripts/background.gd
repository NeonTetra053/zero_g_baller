extends Sprite2D

@export var sway_amplitude := Vector2(160.0, 50.0)
@export var sway_speed := 0.05
var sway_time := 0.0

func _process(delta: float) -> void:
	sway_time += delta * sway_speed

	# Figure-8 motion
	var x = sin(sway_time) * sway_amplitude.x
	var y = sin(sway_time * 2.0) * sway_amplitude.y

	position = Vector2(x, y)
