extends Control
@onready var chamber_bullets = [$Chamber2/sprite, $Chamber2/sprite2, $Chamber2/sprite3, $Chamber2/sprite4, $Chamber2/sprite5, $Chamber2/sprite6]
func load_menu(bullet_chamber):
	var amount = 0
	for i in 6:
		chamber_bullets[i].visible = true
		match bullet_chamber[i]:
			1:
				chamber_bullets[i].play("basic")
			2:
				chamber_bullets[i].play("light")
			3:
				chamber_bullets[i].play("heavy")
			4:
				chamber_bullets[i].play("icy")
			0:
				chamber_bullets[i].play("blank")
				
		if bullet_chamber[i] != 0:
			amount += 1
	$Label4.text = "Bullets per reload: " + str(amount)
	$AnimationPlayer.play("appear")
func _on_next_stage_button_pressed() -> void:
	$AnimationPlayer.play("disappear")
	await get_tree().create_timer(0.5).timeout
	queue_free()
func _physics_process(delta: float) -> void:
	$Chamber2.rotation_degrees -= 0.2
