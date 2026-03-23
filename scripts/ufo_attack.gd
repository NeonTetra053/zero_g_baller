extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("shoot")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		queue_free()
