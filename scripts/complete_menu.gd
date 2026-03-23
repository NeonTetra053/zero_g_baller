extends Control

@onready var lights = [
	$Light1, $Light2, $Light3, $Light4, $Light5, $Light6, $Light7,
	$Light8, $Light9, $Light10, $Light11, $Light12, $Light13, $Light14
]

var top_colors = ["red", "orange", "yellow", "green", "cyan", "blue", "purple"]
var bottom_colors = ["purple", "blue", "cyan", "green", "yellow", "orange", "red"]

func _ready():
	for light in lights:
		light.visible = false
	set_label(1, 1)

func set_label(collected, reward):
	$collected_label.text = "collected " + str(collected) + " coins"
	$reward_label. text = "bonus reward: " + str(reward) + " coins"


func _on_next_stage_button_pressed() -> void:
	get_parent().get_parent().move_to_next_stage()
	visible = false
