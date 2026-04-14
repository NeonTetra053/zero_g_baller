extends Node2D

@onready var cannon = $GameElements/cannon
@onready var ui = $ui
@onready var chamber = $GameElements/chamber
@onready var bullets = $GameElements/bullets
@onready var level = $GameElements/level
@onready var game_elements = $GameElements
var stage = 1
var level_buttons: bool = true
func _ready() -> void:
	$asteroid_buster/asteroid_buster.global_position = $asteroid_marker.global_position
func begin_run():
	ui.visible = true
	ui.initialize_ui(self)
	game_elements.visible = true

	stage = 1
	Game.set_stage(1)
	initiate_stage(1)
	ui.show_stage_start(cannon.bullet_chamber)

	ui.ui_top_bar.set_coin_amount(Game.player_stats.money)
	ui.ui_top_bar.set_level_label(stage)
	game_elements.hp_bar.value = 100 * (Game.player_stats.current_hp / Game.player_stats.max_hp)

	Game.money_changed.connect(ui.ui_top_bar.set_coin_amount)
	Game.hp_changed.connect(func(new_value):
		$GameElements/hp_bar.value = new_value
	)
	#initiate_stage(stage)
	$main_menu_ui/collection_menu.visible = false
func clear_bullets():
	for child in bullets.get_children():
		child.queue_free()
func _on_button_pressed() -> void:
	cannon.set_cannon()

func _on_button_2_pressed() -> void:
	initiate_stage(1)

func _on_button_3_pressed() -> void:
	level.move_enemies()

func next_turn():
	clear_bullets()
	cannon.reload()

	var enemies = level.get_enemies()
	if enemies.size() == 0:
		if level.current_wave < level.total_waves:
			wave_complete()
		else:
			stage_complete()
	else:
		level.move_enemies()
func check_victory():
	var enemies = level.get_enemies()
	if enemies.size() == 0:
		if level.current_wave < level.total_waves:
			wave_complete()
			return 1
		else:
			stage_complete()
			return 2
	else:
		return 0
func wave_complete():
	print("wave complete ", level.current_wave) 
	$ui/wave_complete_menu.play(level.current_wave) 
	await get_tree().create_timer(2.1).timeout 
	clear_bullets() 
	cannon.set_cannon() 
	level.spawn_wave() 
	cannon.blocked = false
func stage_complete():
	$ui/complete_menu.visible = true
	Game.add_money(5)
	$ui/complete_menu.play(level.collected_coins, 5)
func move_to_next_stage():
	stage += 1
	initiate_stage(stage)
func initiate_stage(stage):
	clear_bullets()
	var scene = preload("res://scenes/stage_start_menu.tscn").instantiate()
	ui.add_child(scene)
	scene.load_menu(cannon.bullet_chamber)
	level.generate(stage)
	Game.set_stage(stage)
	cannon.blocked = false
	match stage:
		10:
			cannon.anchored_position = Vector2(80,646)
		_:
			cannon.anchored_position = Vector2(160,646)
	match stage:
		1:
			$GameElements/visual/bg_stars.texture = preload("res://art/background_wide.png")
			$GameElements/cannon.modulate = "ffffff"
		2:
			$GameElements/visual/bg_stars.texture = preload("res://art/background_wide_3.png")
			$GameElements/cannon.modulate = "b7ffff"
	cannon.set_cannon_position()


func _on_main_menu_button_pressed() -> void:
	start_game()
	
func start_game():
	$main_menu_ui.queue_free()
	ui.visible = true
	game_elements.visible = true
	begin_run()


func _on_main_menu_button_2_pressed() -> void:
	$main_menu_ui/collection_menu.appear()
	$main_menu_ui/collection_menu.setup()

func _on_main_menu_button_4_pressed() -> void:
	print("clicked")
	$asteroid_buster/asteroid_buster.visible = true
	$asteroid_buster/asteroid_buster.position = $focus_marker.global_position


func _on_button_4_pressed() -> void:
	initiate_stage(1)


func _on_button_5_pressed() -> void:
	initiate_stage(2)


func _on_button_6_pressed() -> void:
	initiate_stage(3)


func _on_button_7_pressed() -> void:
	initiate_stage(4)


func _on_button_8_pressed() -> void:
	initiate_stage(5)


func _on_button_9_pressed() -> void:
	initiate_stage(6)


func _on_button_10_pressed() -> void:
	initiate_stage(7)


func _on_pause_button_pressed() -> void:
	pause_game()
	ui.show_pause_menu()

func pause_game():
	for bullet in bullets.get_children():
		bullet.freeze = true
	print("PAUSED")
func unpause_game():
	for bullet in bullets.get_children():
		bullet.freeze = false
	print("UNPAUSED")

func leave_stage():
	clear_bullets()
	


func _on_button_12_pressed() -> void:
	initiate_stage(9)


func _on_button_13_pressed() -> void:
	initiate_stage(10)


func _on_button_14_pressed() -> void:
	initiate_stage(11)


func _on_button_15_pressed() -> void:
	initiate_stage(12)


func _on_button_11_pressed() -> void:
	initiate_stage(8)


func _on_button_16_pressed() -> void:
	for button in [$ui/Button4, $ui/Button5, $ui/Button6, $ui/Button7, $ui/Button8, $ui/Button9, $ui/Button10, $ui/Button11, $ui/Button12, $ui/Button13, $ui/Button14, $ui/Button15]:
		button.visible = level_buttons
	level_buttons = !level_buttons


func _on_main_menu_button_endless_pressed() -> void:
	pass # Replace with function body.
