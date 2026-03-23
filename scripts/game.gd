extends Node2D

@onready var cannon = $GameElements/cannon
@onready var ui = $ui
@onready var chamber = $GameElements/chamber
@onready var bullets = $GameElements/bullets
@onready var level = $GameElements/level
@onready var game_elements = $GameElements
var stage = 1
func begin_run():
	ui.visible = true
	ui.initialize_ui(self)
	game_elements.visible = true
	stage = Game.player_stats.current_stage
	
	cannon.set_cannon()
	ui.show_stage_start(cannon.bullet_chamber)
	# Sync UI with data
	ui.ui_top_bar.set_coin_amount(Game.player_stats.money)
	ui.ui_top_bar.set_level_label(Game.player_stats.current_stage)
	game_elements.hp_bar.value = 100*(Game.player_stats.current_hp/Game.player_stats.max_hp)  # initialize HP bar

	# React to future changes
	Game.money_changed.connect(ui.ui_top_bar.set_coin_amount)
	Game.hp_changed.connect(func(new_value):
		print("new value: ", new_value)
		$GameElements/hp_bar.value = new_value
	)
	#initiate_stage(stage)
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
	cannon.set_cannon()

	var enemies = level.get_enemies()
	if enemies.size() == 0:
		stage_complete()
	else:
		# Move remaining enemies
		level.move_enemies()
func check_victory():
	var enemies = level.get_enemies()
	if enemies.size() == 0:
		stage_complete()
func stage_complete():
	$ui/complete_menu.visible = true
	Game.add_money(5)
	$ui/complete_menu.play(level.collected_coins, 5)
func move_to_next_stage():
	stage += 1
	initiate_stage(stage)
func initiate_stage(stage):
	clear_bullets()
	cannon.set_cannon()
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
	cannon.set_cannon_position()


func _on_main_menu_button_pressed() -> void:
	start_game()
	
func start_game():
	$main_menu_ui.queue_free()
	ui.visible = true
	game_elements.visible = true
	begin_run()


func _on_main_menu_button_2_pressed() -> void:
	$main_menu_ui/collection_menu.visible = true


func _on_main_menu_button_4_pressed() -> void:
	$asteroid_buster.visible = true
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
	initiate_stage(10)


func _on_button_10_pressed() -> void:
	initiate_stage(11)


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
	
