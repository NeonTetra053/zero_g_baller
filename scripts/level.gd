extends Node2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_RED, COIN, BOOSTER, EXP
}
const MIN_X = 0
const MAX_X = 9
const TILE_SIZE = 32
const MOVE_TIME = 0.5
var stage_gen = {
	1: [
		{ "pos": Vector2(2, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(3, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(4.5, 6), "type": BrickType.COIN},
		{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_RED},
	],

	2: [
		{ "pos": Vector2(0, 4), "type": BrickType.COIN},
		{ "pos": Vector2(9, 4), "type": BrickType.COIN},
		{ "pos": Vector2(1, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(3, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(4.5, 6), "type": BrickType.COIN},
		{ "pos": Vector2(3, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 11), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 11), "type": BrickType.YELLOW},
		{ "pos": Vector2(3, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(5, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(5, 1), "type": BrickType.YELLOW},
	],
	3: [
		{ "pos": Vector2(2, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(4.5, 3), "type": BrickType.COIN},
		{ "pos": Vector2(3, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4.5, 9), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 2), "type": BrickType.ENEMY_RED},
	],

	4: [
		{ "pos": Vector2(1, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(4, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(5, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(4.5, 4), "type": BrickType.COIN},
		{ "pos": Vector2(3, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 6), "type": BrickType.ENEMY_RED},
	],
	5: [
		{ "pos": Vector2(0, 10), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 10), "type": BrickType.COIN},
		{ "pos": Vector2(2, 10), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 10), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 10), "type": BrickType.COIN},
		{ "pos": Vector2(9, 10), "type": BrickType.YELLOW},
		{ "pos": Vector2(0, 15), "type": BrickType.RED},
		{ "pos": Vector2(9, 15), "type": BrickType.GREEN},
		{ "pos": Vector2(2, 3), "type": BrickType.PURPLE},
		{ "pos": Vector2(7, 3), "type": BrickType.PURPLE},
		{ "pos": Vector2(6, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4.5, 5), "type": BrickType.COIN},
		{ "pos": Vector2(2, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 14), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 14), "type": BrickType.ENEMY_RED},
	],

	6: [
		{ "pos": Vector2(3, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(4, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(5, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 4), "type": BrickType.RED},
		{ "pos": Vector2(8, 4), "type": BrickType.GREEN},
		{ "pos": Vector2(3, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(2, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 8), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4.5, 9), "type": BrickType.COIN},
		{ "pos": Vector2(4.5, 4), "type": BrickType.EXP},
		{ "pos": Vector2(0, 12), "type": BrickType.GREEN},
		{ "pos": Vector2(9, 12), "type": BrickType.RED},
		{ "pos": Vector2(3, 14), "type": BrickType.YELLOW},
		{ "pos": Vector2(4, 14), "type": BrickType.YELLOW},
		{ "pos": Vector2(5, 14), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 14), "type": BrickType.YELLOW},
	],

	7: [
		{ "pos": Vector2(0, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(9, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(2, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(7, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(4, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(5, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 6), "type": BrickType.YELLOW},
		{ "pos": Vector2(6, 6), "type": BrickType.YELLOW},
		{ "pos": Vector2(0, 8), "type": BrickType.RED},
		{ "pos": Vector2(9, 8), "type": BrickType.GREEN},
		{ "pos": Vector2(2, 10), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 10), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(4.5, 11), "type": BrickType.COIN},
		{ "pos": Vector2(0, 12), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(9, 12), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(0, 14), "type": BrickType.PURPLE},
		{ "pos": Vector2(9, 14), "type": BrickType.PURPLE},
	],

	8: [
		{ "pos": Vector2(1, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(2, 3), "type": BrickType.GREEN},
		{ "pos": Vector2(7, 3), "type": BrickType.RED},
		{ "pos": Vector2(3, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(0, 7), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 7), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 7), "type": BrickType.YELLOW},
		{ "pos": Vector2(9, 7), "type": BrickType.YELLOW},
		{ "pos": Vector2(4.5, 8), "type": BrickType.COIN},
		{ "pos": Vector2(2, 11), "type": BrickType.PURPLE},
		{ "pos": Vector2(7, 11), "type": BrickType.PURPLE},
		{ "pos": Vector2(3, 13), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 13), "type": BrickType.ENEMY_RED},
	],
	9: [
		{ "pos": Vector2(4.5, 13), "type": BrickType.BOOSTER},
		{ "pos": Vector2(4.5, 13), "type": BrickType.COIN},
		{ "pos": Vector2(1, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 5), "type": BrickType.YELLOW},
		{ "pos": Vector2(4, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(5, 2), "type": BrickType.PURPLE},
		{ "pos": Vector2(4.5, 4), "type": BrickType.COIN},
		{ "pos": Vector2(3, 8), "type": BrickType.COIN},
		{ "pos": Vector2(6, 8), "type": BrickType.COIN},
		{ "pos": Vector2(3, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 9), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 9), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 6), "type": BrickType.ENEMY_RED},
	],
	10: [
		{ "pos": Vector2(1, 3), "type": BrickType.ORANGE_1},
		{ "pos": Vector2(2, 2), "type": BrickType.ORANGE_1},
		{ "pos": Vector2(3, 1), "type": BrickType.ORANGE_1},
		{ "pos": Vector2(0, 4), "type": BrickType.ORANGE_1},
		{ "pos": Vector2(0, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(0, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(0, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(9, 4), "type": BrickType.ORANGE_2},
		{ "pos": Vector2(8, 3), "type": BrickType.ORANGE_2},
		{ "pos": Vector2(7, 2), "type": BrickType.ORANGE_2},
		{ "pos": Vector2(6, 1), "type": BrickType.ORANGE_2},
		{ "pos": Vector2(9, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(9, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(9, 3), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 2), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 1), "type": BrickType.YELLOW},
		{ "pos": Vector2(4.5, 5), "type": BrickType.BLUE},
		{ "pos": Vector2(4.5, 9), "type": BrickType.BLUE},
		{ "pos": Vector2(4.5, 13), "type": BrickType.BLUE},
		{ "pos": Vector2(4.5, 17), "type": BrickType.BLUE},
		{ "pos": Vector2(2, 9), "type": BrickType.BOOSTER},
		{ "pos": Vector2(7, 9), "type": BrickType.BOOSTER},
		{ "pos": Vector2(6, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 3), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 4), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(9, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(7, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 6), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(9, 6), "type": BrickType.ENEMY_RED},
	],
	11: [
		{ "pos": Vector2(0, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(9, 1), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 5), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(6, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(3, 2), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(1, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(8, 7), "type": BrickType.ENEMY_RED},
		{ "pos": Vector2(0, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(9, 4), "type": BrickType.YELLOW},
		{ "pos": Vector2(1, 8), "type": BrickType.YELLOW},
		{ "pos": Vector2(8, 8), "type": BrickType.YELLOW},
		{ "pos": Vector2(2, 12), "type": BrickType.YELLOW},
		{ "pos": Vector2(7, 12), "type": BrickType.YELLOW},
	]
}
var stage = 1
var collected_coins := 0
var brick_scenes = [preload("res://scenes/brick_red_1.tscn"), preload("res://scenes/brick_purple_1.tscn"), preload("res://scenes/brick_yellow_1.tscn"), preload("res://scenes/brick_green_1.tscn"), preload("res://scenes/brick_blue_1.tscn"), preload("res://scenes/brick_orange_1.tscn"), preload("res://scenes/brick_orange_2.tscn"), preload("res://scenes/enemy_red.tscn"), preload("res://scenes/coin.tscn"), preload("res://scenes/booster.tscn"), preload("res://scenes/exp_object.tscn")]
func generate(number):
	for child in get_children():
		child.queue_free()
	if number > 12:
		number = randi()%4+1
	stage = number
	collected_coins = 0  # Reset coin counter
	for data in stage_gen[number]:
		var grid_pos = data.pos
		var brick_type = data.type
		var new_brick = brick_scenes[brick_type].instantiate()
		add_child(new_brick)
		new_brick.position = grid_pos * 32 + Vector2(16, 16)

		if brick_type == BrickType.ENEMY_RED:
			new_brick.set_meta("dir", -1)     
			new_brick.set_meta("moving", false) 
	$"../../ui/ui_top_bar".set_level_label(number)
func get_occupied_tiles(grid_pos: Vector2, brick_type: int) -> Array:
	var tiles := []

	match brick_type:
		BrickType.YELLOW, BrickType.ORANGE_1, BrickType.ORANGE_2:
			tiles.append(grid_pos)

		BrickType.PURPLE:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2(-1, 0))
			tiles.append(grid_pos + Vector2(1, 0))

		BrickType.RED:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2(0, 1))
			tiles.append(grid_pos + Vector2(1, 1))

		BrickType.GREEN:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2(0, 1))
			tiles.append(grid_pos + Vector2(-1, 1))
		BrickType.BLUE:
			tiles.append(grid_pos)
			tiles.append(grid_pos + Vector2(0, 1))
			tiles.append(grid_pos + Vector2(0, 2))
			tiles.append(grid_pos + Vector2(0, 3))
		BrickType.ENEMY_RED:
			tiles.append(grid_pos)

	return tiles
	
func build_occupancy_map() -> Dictionary:
	var map := {}
	for data in stage_gen[stage]:
		var pos = data.pos
		var type = data.type
		for tile in get_occupied_tiles(pos, type):
			map[tile] = true
	return map


func move_enemies() -> void:
	var occupied = build_occupancy_map()
	var enemies = get_enemies().filter(func(e): return not e.get_meta("moving", false))
	
	# Sort by Y descending so bottom enemies move first
	enemies.sort_custom(func(a, b): return a.position.y > b.position.y)

	for child in enemies:
		var grid_pos = (child.position / TILE_SIZE).floor()

		if grid_pos.y >= 16:
			if child.has_method("attack"): child.attack()
			continue

		# 1. DYNAMIC SYMMETRY
		# Calculate preferred direction based on screen half
		var preferred_dir = -1 if grid_pos.x <= 4.5 else 1
		
		# Check paths
		var target_down = grid_pos + Vector2(0, 1)
		var target_preferred = grid_pos + Vector2(preferred_dir, 0)
		var target_fallback = grid_pos + Vector2(-preferred_dir, 0)
		
		var new_pos = grid_pos

		# 2. DECISION HIERARCHY
		# Priority 1: Down
		if not occupied.has(target_down) and target_down.y <= 16:
			new_pos = target_down
		# Priority 2: Preferred Side (Away from center)
		elif is_in_bounds(target_preferred) and not occupied.has(target_preferred):
			new_pos = target_preferred
		# Priority 3: Fallback Side (Toward center)
		elif is_in_bounds(target_fallback) and not occupied.has(target_fallback):
			new_pos = target_fallback
		else:
			# No moves available
			continue 

		# 3. APPLY MOVE
		if new_pos != grid_pos:
			# Update occupancy map immediately for the next enemy in the loop
			occupied.erase(grid_pos)
			occupied[new_pos] = true
			
			child.set_meta("moving", true)
			var tween = create_tween()
			tween.tween_property(child, "position", new_pos * TILE_SIZE + Vector2(16, 16), MOVE_TIME)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.finished.connect(func(): 
				if is_instance_valid(child): 
					child.set_meta("moving", false)
			)

func is_in_bounds(grid_pos: Vector2) -> bool:
	return grid_pos.x >= MIN_X and grid_pos.x <= MAX_X

func get_enemies() -> Array:
	var enemies := []
	for child in get_children():
		if child.has_method("is_enemy"):
			enemies.append(child)
	return enemies

func on_coin_collected():
	collected_coins += 1
