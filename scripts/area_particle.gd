extends Area2D

@export var explosion_damage: int = 1

func _ready() -> void:
	# 1. Play the animation
	$AnimationPlayer.play("appear")
	
	# 2. Wait a tiny bit for the Area2D to detect overlapping bodies
	await get_tree().create_timer(0.1).timeout
	deal_blast_damage()

func deal_blast_damage():
	# Get everything currently inside the explosion radius
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		# Check if the body is an enemy brick
		if body.has_method("hit"):
			body.hit(explosion_damage)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		queue_free()
