extends ProgressBar

func _process(delta):
	update_color()


func update_color():
	var t := value / max_value  # 0..1

	var color: Color
	if t < 0.5:
		# Red → Yellow
		color = Color.RED.lerp(Color.YELLOW, t * 2.0)
	else:
		# Yellow → Green
		color = Color.YELLOW.lerp(Color.GREEN, (t - 0.5) * 2.0)
	
	self_modulate = color
