extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		# Add to global money
		Game.add_experience(3)
		
		$AnimatedSprite2D.play("pop")
		await get_tree().create_timer(0.3).timeout
		queue_free()
