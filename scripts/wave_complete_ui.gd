extends Control

@onready var lights = [
	$CompleteUi/Light1, $CompleteUi/Light2, $CompleteUi/Light3, $CompleteUi/Light4, $CompleteUi/Light5, $CompleteUi/Light6, $CompleteUi/Light7, $CompleteUi/Light8, $CompleteUi/Light9, $CompleteUi/Light10, $CompleteUi/Light11, $CompleteUi/Light12, $CompleteUi/Light13, $CompleteUi/Light14
]

# Colors for reference (optional)
var top_colors = ["red", "orange", "yellow", "green", "cyan", "blue", "purple"]
var bottom_colors = ["purple", "blue", "cyan", "green", "yellow", "orange", "red"]

func _ready():
	# Initialize all lights off
	for light in lights:
		light.visible = false
func play(wave):
	visible = true
	$AnimationPlayer.play("play")
	for light in lights:
		light.visible = false
	set_label(wave)


# Animate top left->right and bottom right->left simultaneously
func animate_both_rows() -> void:
	var top_row = lights.slice(0, 7)
	var bottom_row = lights.slice(7, 14)

	# Turn on sequence
	for i in range(7):
		top_row[i].visible = true
		bottom_row[6 - i].visible = true  # reversed
		await get_tree().create_timer(0.1).timeout

	# Turn off sequence
	for i in range(7):
		top_row[i].visible = false
		bottom_row[6 - i].visible = false
		await get_tree().create_timer(0.1).timeout

	# Blink 3 times simultaneously
	for t in range(3):
		for i in range(7):
			top_row[i].visible = true
			bottom_row[i].visible = true
		await get_tree().create_timer(0.15).timeout

		for i in range(7):
			top_row[i].visible = false
			bottom_row[i].visible = false
		await get_tree().create_timer(0.15).timeout
	
	for i in range(7):
			top_row[i].visible = true
			bottom_row[i].visible = true
	visible = false
func set_label(wave):
	$CompleteUi/Label2.text = "Wave " + str(wave) + " complete!"

func _on_next_stage_button_pressed() -> void:
	get_parent().get_parent().move_to_next_stage()
	visible = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		await animate_both_rows()
