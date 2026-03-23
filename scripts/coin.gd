extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		# Add to global money
		Game.add_money(1)
		
		# Notify level for per-stage tracking
		if is_instance_valid(get_parent()) and get_parent().has_method("on_coin_collected"):
			get_parent().on_coin_collected()
		$AnimatedSprite2D.play("pop")
		await get_tree().create_timer(0.3).timeout
		queue_free()
