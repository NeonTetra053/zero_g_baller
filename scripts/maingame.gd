extends Node
class_name MainGame

## ===== DATA =====
var player_stats: PlayerStats

## ===== SIGNALS =====
signal money_changed(amount: int)
signal stage_changed(stage: int)
signal hp_changed(new_hp: int)
func _ready():
	_load_or_create_stats()


func _load_or_create_stats() -> void:
	player_stats = PlayerStats.new()
	player_stats.initialize()

	ensure_save_exists(
		"res://save/player_stats_save.tres",
		"user://save/player_stats_save.tres"
	)

	player_stats.load_from_file("user://save/player_stats_save.tres")

func add_money(amount: int) -> void:
	player_stats.money += amount
	emit_signal("money_changed", player_stats.money)
	save_stats()
func add_experience(amount: int) -> void:
	player_stats.exp += amount
	save_stats()
func reduce_hp(amount: int) -> void:
	print("CURRENT HP ", player_stats.current_hp)
	player_stats.current_hp = max(player_stats.current_hp - amount, 0)  # clamp at 0
	print("HIT TAKEN ", player_stats.current_hp)
	emit_signal("hp_changed", 100*(player_stats.current_hp/player_stats.max_hp))
func set_stage(stage: int) -> void:
	player_stats.set_current_stage(stage)
	save_stats()

func save_stats() -> void:
	player_stats.save_to_file("user://save/player_stats_save.tres")

# -----------------
# Utilities
# -----------------
func ensure_save_exists(res_path: String, user_path: String) -> void:
	var dir := DirAccess.open("user://")
	var folder := user_path.get_base_dir()

	if not dir.dir_exists(folder):
		dir.make_dir_recursive(folder)

	if not FileAccess.file_exists(user_path):
		var res_data := ResourceLoader.load(res_path)
		if res_data:
			ResourceSaver.save(res_data, user_path)
