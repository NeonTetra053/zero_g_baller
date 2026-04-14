extends Node2D

# Reuse your existing BrickType enum [cite: 1]
enum BrickType { RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_RED, COIN, BOOSTER, EXP }

const TILE_SIZE = 32
const GRID_W := 10
const GRID_H := 18
const MOVE_TIME = 0.5
var current_hp: float = 5.0
var MAX_HP: float = 5.0
@export var enemy_scene = preload("res://scenes/enemy_square.tscn")
@export var coin_scene = preload("res://scenes/coin.tscn") # Coin scene added
var gameref
func set_gameref(new_gameref):
	gameref = new_gameref
var grid = []
var turn_count = 0 # Held inside script
func clear_level():
	for child in get_children():
		child.queue_free()
func _ready():
	# Initialize an empty grid [cite: 1]
	for y in range(GRID_H):
		var row = []
		for x in range(GRID_W):
			row.append(-1)
		grid.append(row)

# Moved up to ensure availability for spawn_enemy and move_enemies 
func grid_to_world(gp: Vector2) -> Vector2:
	return Vector2(gp.x * TILE_SIZE + 16, gp.y * TILE_SIZE + 16)

func start_endless():
	current_hp = 5.0
	MAX_HP = 5.0
	turn_count = 1 
	gameref.update_top_bar_label()
	get_parent().hp_bar.value = current_hp/MAX_HP * 100
	var cannon_node = get_parent().get_node("cannon")
	if cannon_node:
		cannon_node.set_cannon([1, 0, 0, 0, 0, 0])
	
	for y in range(1, 5):
		spawn_new_row(y)
func spawn_new_row(y_pos: int = 1):
	var count = randi_range(3, 5)
	var available_slots = range(GRID_W)
	available_slots.shuffle()

	var new_hp = 2 + floor(turn_count / 3.0)

	for i in range(count):
		var x = available_slots.pop_back()
		# Use the y_pos variable instead of hardcoded 1
		spawn_enemy(Vector2(x, y_pos), new_hp)

func spawn_enemy(gp: Vector2, hp_to_set: int): # Added hp_to_set parameter
	var enemy = enemy_scene.instantiate() 
	add_child(enemy)
	enemy.add_to_group("enemies") 
	
	enemy.grid_pos = gp
	enemy.position = grid_to_world(gp)
	grid[int(gp.y)][int(gp.x)] = BrickType.ENEMY_RED
	
	# Call the set_hp function you already have in your enemy script
	if enemy.has_method("set_hp"):
		enemy.set_hp(hp_to_set)
func spawn_coin():
	# Find unoccupied tiles
	var empty_slots = []
	for y in range(1, GRID_H - 2):
		for x in range(GRID_W):
			if grid[int(y)][int(x)] == -1:
				empty_slots.append(Vector2(x, y))
	
	if empty_slots.size() > 0:
		var target_pos = empty_slots[randi() % empty_slots.size()]
		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.add_to_group("coins")
		coin.position = grid_to_world(target_pos)
		grid[int(target_pos.y)][int(target_pos.x)] = BrickType.COIN

func despawn_all_coins():
	# Remove all coin nodes and clear their grid data
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.queue_free()
	
	# Scour grid for any coin markers and clear them
	for y in range(GRID_H):
		for x in range(GRID_W):
			if grid[int(y)][int(x)] == BrickType.COIN:
				grid[int(y)][int(x)] = -1

func move_enemies():
	# 1. Despawn all coins before enemies move
	despawn_all_coins()
	
	# Turn starts when move_enemies is called
	turn_count += 1
	gameref.update_top_bar_label()
	# 2. Get all enemies and sort them 
	var enemies = get_tree().get_nodes_in_group("enemies")
	enemies.sort_custom(func(a, b): return a.grid_pos.y > b.grid_pos.y)

	for enemy in enemies:
		var gp = enemy.grid_pos
		
		# 3. Clear old grid position 
		grid[int(gp.y)][int(gp.x)] = -1
		
		# 4. Check for Game Over 
		if gp.y >= GRID_H - 2:
			if enemy.has_method("attack"):
				enemy.attack()
			continue

		# 5. Calculate and set new position 
		var target = gp + Vector2(0, 1)
		grid[int(target.y)][int(target.x)] = BrickType.ENEMY_RED
		enemy.grid_pos = target
		
		# 6. Animate movement 
		var tween = create_tween()
		tween.tween_property(enemy, "position", grid_to_world(target), MOVE_TIME)

	# 7. Spawn new row 
	spawn_new_row()
	
	# 8. Every 2nd turn, spawn a coin
	if turn_count % 2 == 0:
		spawn_coin()
	if turn_count % 3 == 0:
		gameref.show_buff_menu()
func get_turn_count() -> int:
	return turn_count
func reduce_hp(amount: int):
	current_hp = max(current_hp - amount, 0)
	get_parent().hp_bar.value = current_hp/MAX_HP * 100
	if current_hp == 0:
		gameref.endless_lost()
func count_hit(amount):
	get_parent().add_streak(amount)
func add_hp(amount: float):
	# Heal current HP without exceeding the cap
	current_hp = min(current_hp + amount, MAX_HP)
	
	# Update the UI bar immediately
	if get_parent() and get_parent().has_node("hp_bar"):
		get_parent().hp_bar.value = (current_hp / MAX_HP) * 100
	
	print("HP added. Current health: ", current_hp)
func spawn_shooting_stars(count: int):
	var star_scene = preload("res://scenes/star.tscn")
	for i in range(count):
		
		var star = star_scene.instantiate()
		add_child(star)
		
		# Set a random starting position above the screen
		var start_x = randf_range(0, GRID_W * TILE_SIZE)
		star.position = Vector2(start_x+64, -10)
		
		# If your shooting star scene has a "launch" or "init" method, call it here
		if star.has_method("launch"):
			star.launch()
		
		# Slight delay between stars for visual effect
		await get_tree().create_timer(0.2).timeout
