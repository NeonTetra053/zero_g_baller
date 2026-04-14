extends Node2D

func _ready() -> void:
	# 1. Basic Setup
	$AnimatedSprite2D2.play("coin")
	z_index = 100 
	
	# Save the starting point (where the enemy died)
	var start_pos = global_position 
	
	# --- PHASE 1: THE BURST ---
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var burst_target = start_pos + (random_direction * randf_range(30, 50))
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position", burst_target, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	var fly_tween = create_tween()
	fly_tween.tween_interval(1.0) # Hang in the air
	
	fly_tween.tween_callback(self.start_flight)

func start_flight():
	var canvas_transform = get_canvas_transform()
	
	var view_offset = -canvas_transform.origin / canvas_transform.get_scale()
	
	var view_size = get_viewport_rect().size / canvas_transform.get_scale()
	
	var target_pos = view_offset + Vector2(view_size.x, 0)
	
	var final_tween = create_tween().set_parallel(true)
	final_tween.tween_property(self, "global_position", target_pos, 0.5)\
		.set_ease(Tween.EASE_OUT)
	
	final_tween.chain().tween_callback(self.finalize_collect)

func finalize_collect() -> void:
	# 1. Add the money to your game state
	Game.add_money(1)
	
	# 2. Delete the coin node
	queue_free()
