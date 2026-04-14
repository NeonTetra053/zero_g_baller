extends Control

@onready var lights = [
	$Light1, $Light2, $Light3, $Light4, $Light5, $Light6, $Light7, $Light8, $Light9, $Light10, $Light11, $Light12, $Light13, $Light14
]


func _ready():
	# Initialize all lights off
	for light in lights:
		light.visible = false
	play(1,1)
# Play full animation with top and bottom rows simultaneously
func play(col, rew):
	for light in lights:
		light.visible = false
		set_label(col, rew)
	await animate_both_rows()


# Animate top left->right and bottom right->left simultaneously
func animate_both_rows() -> void:
	var top_row = lights.slice(0, 7)
	var bottom_row = lights.slice(7, 14)
	for j in range(10):
		for i in range(7):
				top_row[i].visible = true
				bottom_row[i].visible = true
		await get_tree().create_timer(0.3).timeout
		for i in range(7):
				top_row[i].visible = false
				bottom_row[i].visible = false
		await get_tree().create_timer(0.3).timeout
	
func set_label(collected, reward):
	$collected_label.text = "collected " + str(collected) + " coins"
	$reward_label. text = "bonus reward: " + str(reward) + " coins"


func _on_next_stage_button_pressed() -> void:
	get_parent().get_parent().move_to_next_stage()
	visible = false
