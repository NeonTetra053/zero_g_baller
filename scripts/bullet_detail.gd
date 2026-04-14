extends Control

@onready var sprite = $TextureRect/sprite
@onready var name_label = $TextureRect/name_label
@onready var speed_label = $TextureRect/speed_label
@onready var size_label = $TextureRect/size_label
@onready var mass_label = $TextureRect/mass_label
@onready var stability_label = $TextureRect/stability_label
@onready var desc_label = $TextureRect/desc_info
@onready var panel = $TextureRect
@onready var equipped_label = $TextureRect/buttons_label2
@onready var upgrade_names = [
$TextureRect/upgrade_name_1, $TextureRect/upgrade_name_2, $TextureRect/upgrade_name_3
]

@onready var upgrade_descs = [
$TextureRect/upgrade_desc_1, $TextureRect/upgrade_desc_2, $TextureRect/upgrade_desc_3
]

@onready var upgrade_bars = [
$TextureRect/upgrade_bar_1, $TextureRect/upgrade_bar_2, $TextureRect/upgrade_bar_3
]
@onready var price_labels = [
	$TextureRect/buy_1, $TextureRect/buy_2, $TextureRect/buy_3
]
const BULLET_STATS = {
	"BASIC": {
		"name": "Standard Bullet",
		"anim": "basic",
		"speed": 2.0,
		"size": 1.3,
		"mass": 1.0,
		"stability": 2.5,
		"desc": "Standard issue ammunition for cosmic combat. No special effects. Balanced speed and power."
	},
	"LIGHT": {
		"name": "Light Bullet",
		"anim": "light",
		"speed": 2.5,
		"size": 0.9,
		"mass": 0.5,
		"stability": 2.5,
		"desc": "A lightweight projectile with high speed. Less mass makes it agile but less impactful."
	},
	"HEAVY": {
		"name": "Heavy Bullet",
		"anim": "heavy",
		"speed": 1.4,
		"size": 1.5,
		"mass": 5.0,
		"stability": 2.0,
		"desc": "Large bullet made from dense alloy. Slower, but more powerful than a standard bullet."
	},
	"FROZEN": {
		"name": "Frozen Bullet",
		"anim": "icy",
		"speed": 1.2,
		"size": 1.3,
		"mass": 1.0,
		"stability": 1.5,
		"desc": "Bullet covered in condensed ice. Medium size and mass, low stability. Hard to stop once fired."
	},
	"SHOCK": {
		"name": "Shock Bullet",
		"anim": "shock",
		"speed": 2.5,
		"size": 0.9,
		"mass": 4.0,
		"stability": 2.0,
		"desc": "Electrically enhanced projectile. Fast and heavy. On stopping, it surges forward for a short distance."
	},
	"NANO": {
		"name": "Nano Shot",
		"anim": "nano",
		"speed": 0.7,
		"size": 0.35,
		"mass": 0.1,
		"stability": 1.0,
		"desc": "Microscale projectile with minimal mass. Highly radioactive and unstable."
	}
}
const BULLET_UPGRADE_META := {
	"BASIC": {
		"Propulsion": {
			"desc": "Increases initial speed."
		},
		"Stability": {
			"desc": "Reduced momentum loss."
		},
		"Density": {
			"desc": "Increases mass."
		}
	},

	"LIGHT": {
		"Velocity": {
			"desc": "Increases initial speed."
		},
		"Aerodynamics": {
			"desc": "Retains velocity upon collision."
		},
		"Modulation": {
			"desc": "Reduces slowing effects and amplifies speed buffs."
		}
	},

	"HEAVY": {
		"Compression": {
			"desc": "Concentrates mass, increases force."
		},
		"Impact Damp": {
			"desc": "Retains velocity upon collision."
		},
		"Integrity": {
			"desc": "Increases damage."
		}
	},

	"FROZEN": {
		"Snow Coat": {
			"desc": "Increases initial speed."
		},
		"Condensed Ice": {
			"desc": "Increases mass."
		},
		"Smoothness": {
			"desc": "Reduces frictional instability during motion."
		}
	},

	"SHOCK": {
		"Capacitor": {
			"desc": "Increases aftershock power."
		},
		"Efficiency": {
			"desc": "Reduces momentum loss."
		},
		"Alignment": {
			"desc": "Optimizes directional control of electrical aftershock."
		}
	},

	"NANO": {
		"coherence": {
			"desc": "Improves nanostructural cohesion, reducing erratic behavior."
		},
		"density": {
			"desc": "Increases particle concentration for improved consistency."
		},
		"penetration": {
			"desc": "Enhances structural focus, improving barrier traversal."
		}
	}
}
const BULLET_UPGRADE_ORDER := {
	"BASIC":  ["Propulsion", "Stability", "Density"],
	"LIGHT":  ["Velocity", "Aerodynamics", "Modulation"],
	"HEAVY":  ["Compression", "Impact Damp", "Integrity"],
	"FROZEN": ["Snow Coat", "Condensed Ice", "Smoothness"],
	"SHOCK":  ["Capacitor", "Efficiency", "Alignment"],
	"NANO":   ["coherence", "density", "penetration"]
}

const UPGRADE_PRICES := [10, 25, 50, 100, 200]
var current_bullet_id: String = ""
func show_bullet(bullet_id: String):
	current_bullet_id = bullet_id  # store it for upgrades
	var data = BULLET_STATS[bullet_id]
	if Game.player_stats.equipped_bullet == bullet_id:
		equipped_label.text = "EQUIPPED"
	else:
		equipped_label.text = "EQUIP"
	sprite.play(data.anim)
	name_label.text = data.name
	speed_label.text = "Speed: x%.1f" % data.speed
	size_label.text = "Size: x%.2f" % data.size
	mass_label.text = "Mass: %.1f" % data.mass
	stability_label.text = "Stability: %.1f" % data.stability
	desc_label.text = data.desc
	# Top-to-bottom reveal using rect_size
	panel.visible = true
	panel.size.y = 0  # start collapsed

	var full_height = 680  # set this to your TextureRect’s normal height
	var tween = create_tween()
	tween.tween_property(panel, "size:y", full_height, 0.25)
func show_upgrades(bullet_id: String, player_stats = Game.player_stats) -> void:
	var order = BULLET_UPGRADE_ORDER[bullet_id]
	var player_data = player_stats.bullet_upgrades[bullet_id]
	var meta = BULLET_UPGRADE_META[bullet_id]

	for i in 3:
		var upgrade_name = order[i]
		var level = player_data[upgrade_name]

		# Set name and description
		upgrade_names[i].text = upgrade_name
		upgrade_descs[i].text = meta[upgrade_name].desc

		# Build textual upgrade bar "[X] [X] [ ] [ ] [ ]"
		var bar_text := ""
		for j in 5:  # max 5 levels
			if j < level:
				bar_text += "[X] "
			else:
				bar_text += "[ ] "
		upgrade_bars[i].text = bar_text.strip_edges()  # remove trailing space

		# Set price text for next level
		if level < 5:
			price_labels[i].text = "Buy %dG" % UPGRADE_PRICES[level]
		else:
			price_labels[i].text = "MAX"
func _on_button_pressed() -> void:
	visible = false
	$TextureRect.size.y = 680


func _buy_upgrade(slot_index: int, player_stats = Game.player_stats) -> void:
	if current_bullet_id == "":
		return  # no bullet selected

	var bullet_id = current_bullet_id  # use stored bullet id
	var upgrade_name = BULLET_UPGRADE_ORDER[bullet_id][slot_index]
	var current_level = player_stats.get_upgrade_level(bullet_id, upgrade_name)

	if current_level >= 5:
		return # already maxed

	var price = UPGRADE_PRICES[current_level]
	if player_stats.money < price:
		print("Not enough money to buy upgrade.")
		return

	# Deduct money and upgrade the bullet
	player_stats.money -= price
	player_stats.upgrade_bullet(bullet_id, upgrade_name)

	# Refresh the UI for upgrades
	show_upgrades(bullet_id, player_stats)

	# Optionally save immediately
	Game.save_stats()
	print("Bought upgrade %s for bullet %s, spent %dG" % [upgrade_name, bullet_id, price])

func _on_buy_button_1_pressed() -> void:
	_buy_upgrade(0)

func _on_buy_button_2_pressed() -> void:
	_buy_upgrade(1)

func _on_buy_button_3_pressed() -> void:
	_buy_upgrade(2)


func _on_equip_button_pressed() -> void:
	if current_bullet_id == "":
		return
		
	# Update the global stats [cite: 48]
	Game.player_stats.equip_bullet(current_bullet_id)
	Game.save_stats()
	
	# Update the label to show it is now equipped [cite: 39]
	equipped_label.text = "EQUIPPED" 
	print("Equipped bullet: ", current_bullet_id)
