extends AnimatedSprite2D

func _on_button_pressed() -> void:
	# Check the current animation name
	if animation == "off":
		play("on")
	else:
		play("off")
