extends Control

# Data structure with IDs
var buff_data = {
	"larger_barrel": {
		"name": "Larger barrel",
		"desc": "Increases size and mass by 10%\nDecreases damp by 3%"
	},
	"smaller_barrel": {
		"name": "Smaller barrel",
		"desc": "Decreases size and mass by 10%\nincreases speed by 3%"
	},
	"enhanced_coating": {
		"name": "Enhanced coating",
		"desc": "Decreases bullet's damp by 5%"
	},
	"firepower": {
		"name": "Firepower",
		"desc": "Increases bullet's speed by 5%"
	},
	"extra_hp": {
		"name": "Quick Repair",
		"desc": "Restore +5 HP to the cannon."
	},
	"extra_damage": {
		"name": "Overcharged Coils",
		"desc": "Increases base bullet damage by 1."
	},
	"range_plus": {
		"name": "Extended Rails",
		"desc": "Increases cannon's position range by 10.\n(max 120)"
	},
	"shooting_star": {
		"name": "Meteor Shower",
		"desc": "Immediately summons 3 shooting stars. Stars deals 5 damage to enemies in their way."
	}
}

var animation_map = {
	"larger_barrel": "size_plus",
	"smaller_barrel": "size_minus",
	"enhanced_coating": "damp_minus",
	"firepower": "speed_plus",
	"extra_hp": "hp_up",
	"extra_damage": "dmg_plus",
	"range_plus": "range_plus",
	"shooting_star": "star_icon"
}

@onready var buff_select_sprites = [$BuffMenu/BuffSelect, $BuffMenu/BuffSelect2, $BuffMenu/BuffSelect3]
@onready var selected_buff_name = $selected_buff_name
@onready var selected_buff_desc = $selected_buff_description
@onready var buff_name_labels = [$buff_name_1, $buff_name_2, $buff_name_3]
@onready var buff_sprites = [$BuffMenu/AnimatedSprite2D, $BuffMenu/AnimatedSprite2D2, $BuffMenu/AnimatedSprite2D3]

var current_buff_ids = [] # Now tracking IDs instead of Names
var last_clicked_index = -1     
var gameref

func set_gameref(new_gameref):
	gameref = new_gameref

func _ready() -> void:
	setup_random_buffs()
	hide_highlights()

func setup_random_buffs():
	var all_ids = buff_data.keys()
	all_ids.shuffle()
	current_buff_ids = all_ids.slice(0, 3)
	
	for i in range(3):
		var b_id = current_buff_ids[i]
		var data = buff_data[b_id]
		
		buff_name_labels[i].text = data["name"]
		
		if animation_map.has(b_id):
			buff_sprites[i].play(animation_map[b_id])

func hide_highlights():
	for sprite in buff_select_sprites:
		sprite.visible = false

func handle_buff_click(index: int):
	if last_clicked_index != index:
		last_clicked_index = index
		
		var b_id = current_buff_ids[index]
		var data = buff_data[b_id]
		selected_buff_name.text = data["name"]
		selected_buff_desc.text = data["desc"]
		
		hide_highlights()
		buff_select_sprites[index].visible = true
	else:
		confirm_choice(current_buff_ids[index])

func confirm_choice(buff_id):
	if buff_id == "extra_hp":
		if gameref and gameref.endless_mode:
			gameref.endless_mode.add_hp(5)
	
	# New logic for Shooting Stars
	if buff_id == "shooting_star":
		if gameref and gameref.endless_mode:
			gameref.endless_mode.spawn_shooting_stars(3)

	if gameref and gameref.cannon:
		gameref.cannon.add_buff(buff_id)
		
	self.queue_free()

func _on_buff_button_1_pressed() -> void: handle_buff_click(0)
func _on_buff_button_2_pressed() -> void: handle_buff_click(1)
func _on_buff_button_3_pressed() -> void: handle_buff_click(2)


func _on_cancel_button_pressed() -> void:
	self.queue_free() 
