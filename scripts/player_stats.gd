extends Resource
class_name PlayerStats
const exp_requirement = [
	26, 52, 78, 116, 150, 177, 210, 246, 285, 345,
	396, 465, 522, 600, 663, 768, 942, 1152, 1413, 1731,
	2118, 2595, 3177, 3891, 4767, 5838, 7152, 8757, 10725, 13137,
	16137, 20049, 25104, 31335, 39519, 49683, 61779, 77004, 99639, 122259,
	149637, 183267, 224379, 273699, 332137, 404553, 505023, 619041, 756525
]
@export var unlocked_bullets: Array[String] = ["BASIC"]
@export var money: int = 0
@export var exp: int = 0
@export var highest_stage: int = 1
@export var current_stage: int = 1
@export var equipped_bullet: String = "BASIC"
@export var bullet_upgrades := {
	"BASIC": {
		"Propulsion": 0,
		"Stability": 0,
		"Density": 0
	},
	"LIGHT": {
		"Velocity": 0,
		"Aerodynamics": 0,
		"Modulation": 0
	},
	"HEAVY": {
		"Compression": 0,
		"Impact Damp": 0,
		"Integrity": 0
	},
	"FROZEN": {
		"Snow Coat": 0,
		"Condensed Ice": 0,
		"Smoothness": 0
	},
	"SHOCK": {
		"Capacitor": 0,
		"Efficiency": 0,
		"Alignment": 0
	},
	"NANO": {
		"coherence": 0,
		"density": 0,
		"penetration": 0
	}
}
var max_hp : float= 10
var current_hp : float= max_hp

func increase_money(n: int):
	money += n
func increase_exp(n: int):
	exp += n
func load_from_file(file_path: String) -> bool:
	var loaded_resource = ResourceLoader.load(file_path)
	if loaded_resource == null or not loaded_resource is PlayerStats:
		return false

	var loaded_save = loaded_resource as PlayerStats
	money = loaded_save.money
	exp = loaded_save.exp
	highest_stage = loaded_save.highest_stage
	current_stage = loaded_save.current_stage
	unlocked_bullets = loaded_save.unlocked_bullets.duplicate()
	bullet_upgrades = loaded_save.bullet_upgrades.duplicate()
	return true
func save_to_file(file_path: String) -> void:
	var result = ResourceSaver.save(self, file_path)
	if result == OK:
		print("PlayerStats data saved successfully to: ", file_path)
	else:
		print("Error saving PlayerStats data: ", result)
func initialize():
	money= 0
	highest_stage = 1
	current_stage = 1
func set_current_stage(stage):
	current_stage = stage
	highest_stage = max(current_stage, highest_stage)
func is_bullet_unlocked(bullet_id: String) -> bool:
	return unlocked_bullets.has(bullet_id.to_upper())
	
func unlock_bullet(bullet_id: String) -> bool:
	bullet_id = bullet_id.to_upper()

	if unlocked_bullets.has(bullet_id):
		return false

	unlocked_bullets.append(bullet_id)
	return true
	
func get_upgrade_level(bullet_id: String, upgrade_id: String) -> int:
	return bullet_upgrades[bullet_id][upgrade_id]

func upgrade_bullet(bullet_id: String, upgrade_id: String) -> bool:
	if bullet_upgrades[bullet_id][upgrade_id] >= 5:
		return false

	bullet_upgrades[bullet_id][upgrade_id] += 1
	return true
func equip_bullet(bullet_id: String):
	equipped_bullet = bullet_id.to_upper() # [cite: 56]
