extends Node2D
@onready var cannon = $GameElements/cannon
@onready var ui = $ui
@onready var chamber = $GameElements/chamber
@onready var bullets = $GameElements/bullets
@onready var level = $GameElements/level
@onready var endless_mode = $GameElements/endless_mode
@onready var game_elements = $GameElements
@onready var camera = $Camera2D
var stage = 1
var level_buttons: bool = true
var is_endless_mode = false
var current_hp: float = 5.0
const MAX_HP: float = 5.0

func _ready() -> void:
	$asteroid_buster/asteroid_buster.global_position = $asteroid_marker.global_position
	$ui/pause_menu.initialize_menu(self)
	$ui/game_over_ui.set_gameref(self)
	level.set_gameref(self)
	endless_mode.set_gameref(self)
	cannon.camera = self.camera
	camera.make_current()
	$main_menu_ui/buff_menu.set_gameref(self)
func begin_run():
	ui.visible = true
	ui.initialize_ui(self)
	game_elements.visible = true
	reset_hp()
	stage = 1
	cannon._reset_camera()
	Game.set_stage(1)
	initiate_stage(1)
	ui.show_stage_start(cannon.bullet_chamber)

	ui.ui_top_bar.set_coin_amount(Game.player_stats.money)
	ui.ui_top_bar.set_level_label(stage)
	game_elements.hp_bar.value = 100 * (Game.player_stats.current_hp / Game.player_stats.max_hp)

	Game.money_changed.connect(ui.ui_top_bar.set_coin_amount)
	Game.hp_changed.connect(func(new_value):
		$GameElements/CanvasLayer/hp_bar.value = new_value
		if new_value <= 0:
			trigger_game_over()
	)
	
	$main_menu_ui/collection_menu.visible = false

func trigger_game_over():
	cannon.blocked = true
	$ui/game_over_ui.visible = true
	if $ui/game_over_ui.has_method("play"):
		$ui/game_over_ui.play()
func clear_bullets():
	for child in bullets.get_children():
		child.queue_free()
func _on_button_pressed() -> void:
	cannon.set_cannon()

func _on_button_2_pressed() -> void:
	initiate_stage(1)

func _on_button_3_pressed() -> void:
	#level.move_enemies()
	if is_endless_mode:
		endless_mode.move_enemies()
func next_turn():
	clear_bullets()
	update_top_bar_label()
	# ENDLESS MODE LOGIC
	if is_endless_mode:
		if is_instance_valid(endless_mode):
			endless_mode.move_enemies()
			# Reload with the endless mode challenge preset
			cannon.set_cannon([1, 0, 0, 0, 0, 0])
		return

	# STANDARD STAGE MODE LOGIC
	cannon.reload()
	var enemies = level.get_enemies()
	
	if enemies.size() == 0:
		if level.current_wave < level.total_waves - 1:
			wave_complete()
		else:
			stage_complete()
	else:
		level.move_enemies()

func check_victory():
	if is_endless_mode:
		return 0

	var enemies = level.get_enemies()
	if enemies.size() == 0:
		if level.current_wave < level.total_waves - 1:
			wave_complete()
			return 1
		else:
			stage_complete()
			return 2
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
	level.visible = true
	reset_hp()
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

func reset_hp():
	current_hp = MAX_HP
	Game.emit_signal("hp_changed", 100.0)
func _on_main_menu_button_pressed() -> void:
	start_game()
	
func start_game():
	$main_menu_ui.visible = false
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
	initiate_stage(15)


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
	level.clear_level()
	


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
	start_endless_mode()
	
func start_endless_mode():
	$main_menu_ui.visible = false
	ui.visible = true
	game_elements.visible = true
	is_endless_mode = true
	clear_bullets()
	cannon._reset_camera()
	# Hide the standard level and show endless mode
	level.visible = false
	endless_mode.visible = true
	
	# Initialize the endless mode script
	endless_mode.start_endless() 
	update_top_bar_label()
	# Open the UI
	ui.visible = true
	game_elements.visible = true
	cannon.blocked = false


func _on_static_body_2d_2_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		body.force_stop()
		body.bullet_stopped()
		
		body.queue_free()

func return_to_main_menu():
	# 1. Clear any active bullets to prevent errors
	clear_bullets()
	level.clear_level()
	endless_mode.clear_level()
	endless_mode.visible = false
	# 2. Reset game state flags
	is_endless_mode = false
	
	# 3. Hide game UI and elements
	ui.visible = false
	game_elements.visible = false
	
	# 4. Reload the main menu scene
	
	$main_menu_ui.visible = true
	# 5. Ensure the game is unpaused so buttons work
	unpause_game()

func update_top_bar_label():
	if is_endless_mode:
		var current_turn = endless_mode.get_turn_count() 
		ui.ui_top_bar.set_level_label_string("Turn " + str(current_turn))
	else:
		var label_text = "Stage " + str(stage)
		ui.ui_top_bar.set_level_label_string(label_text)

func show_buff_menu():
	var scene = preload("res://scenes/buff_menu.tscn").instantiate()
	game_elements.add_child(scene)
	scene.set_gameref(self)

func endless_lost():
	$ui/game_over_ui.play()


func _on_cam_zoom_button_pressed() -> void:
	if cannon.camera_zoom_in:
		cannon.camera_zoom_in = false
		$GameElements/CanvasLayer/cam_zoom_button/AnimatedSprite2D.play("no")
	else:
		cannon.camera_zoom_in = true
		$GameElements/CanvasLayer/cam_zoom_button/AnimatedSprite2D.play("yes")
