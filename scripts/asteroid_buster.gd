extends Node2D
class_name RocketGacha

const GACHA_COST := 0
const STOP_TARGET_Y := 500.0 
const ALL_BULLETS := ["BASIC", "LIGHT", "HEAVY", "FROZEN", "SHOCK", "NANO"]
# Your requested coordinates
const TARGET_POSITIONS = {
	"COMMON": 1400.0,
	"RARE": 2400.0,
	"LEGENDARY": 3400.0
}

const POOLS = {
	"COMMON": ["BASIC", "LIGHT"],
	"RARE": ["HEAVY", "FROZEN"],
	"LEGENDARY": ["SHOCK", "NANO"]
}

@onready var rocket = $rocket
@onready var world_container = $world_container
@onready var reward_sprite: AnimatedSprite2D = $reward
@onready var launch_button = $Button
@onready var ui_label = $ui_top_bar/Label
@onready var particle_set = [$rocket/CPUParticles2D, $rocket/CPUParticles2D2, $rocket/CPUParticles2D3, $rocket/CPUParticles2D4]
@onready var planets = {
	"COMMON": $world_container/blue_planet,
	"RARE": $world_container/purple_planet,
	"LEGENDARY": $world_container/yellow_planet
}
@onready var space_bg=$gacha_space_bg
@onready var stars_bg=$bg
var is_launching := false
var reward_claimed := false
var predetermined_reward := ""
var _bg_start_pos: Vector2
var _space_start_pos: Vector2
func _ready() -> void:
	_bg_start_pos = Vector2(-228, -416)
	_space_start_pos = Vector2(160, 110)
	reset_gacha_view()

func reset_gacha_view() -> void:
	_set_particles_emitting(false)
	stars_bg.position = _bg_start_pos
	space_bg.position = _space_start_pos
	reward_sprite.visible = false
	reward_sprite.stop()
	launch_button.visible = true
	$collect_button.visible = false
	ui_label.text = str(Game.player_stats.money)
	is_launching = false
	reward_claimed = false
	world_container.position = Vector2(0, 0)
	rocket.position = Vector2(160, STOP_TARGET_Y)

func buy_gacha_shot() -> void:
	if is_launching or Game.player_stats.money < GACHA_COST:
		return
	
	is_launching = true
	reward_claimed = false
	launch_button.visible = false
	
	Game.player_stats.money -= GACHA_COST
	Game.save_stats()
	ui_label.text = str(Game.player_stats.money)
	
	# 1. Roll for Rarity (60/30/10)
	var roll = randf()
	var rarity = "COMMON"
	if roll > 0.0: rarity = "LEGENDARY" # 10%
	elif roll > 0.6: rarity = "RARE"    # 30%
	
	# 2. Get specific reward logic
	var result = _get_reward_for_rarity(rarity)
	predetermined_reward = result.id
	
	# 3. Launch
	_perform_launch_sequence(rarity)

func _get_reward_for_rarity(rarity: String) -> Dictionary:
	print(rarity)
	if rarity == "COMMON":
		Game.player_stats.money += 5
		return {"id": "COIN_5", "rarity": "COMMON"}
	elif rarity == "RARE":
		Game.player_stats.money += 10
		return {"id": "COIN_10", "rarity": "RARE"}
	else:
		# Legendary: Unlock a random locked bullet
		var locked := []
		for bullet_id in ALL_BULLETS:
			if not Game.player_stats.is_bullet_unlocked(bullet_id):
				locked.append(bullet_id)
		
		if locked.is_empty():
			return {"id": "COIN_50", "rarity": "LEGENDARY"}
		
		return {"id": locked.pick_random(), "rarity": "LEGENDARY"}
func _perform_launch_sequence(rarity: String) -> void:
	world_container.position.y = 0
	
	# --- 1. Calculate Background Offsets ---
	var space_offset := 0.0
	var stars_offset := 0.0
	
	match rarity:
		"COMMON":
			space_offset = 100.0
			stars_offset = 70.0
		"RARE":
			space_offset = 200.0
			stars_offset = 140.0
		"LEGENDARY":
			space_offset = 300.0
			stars_offset = 210.0

	# 2. Shake
	var shake_tween = create_tween()	
	
	for i in range(12):
		var offset = Vector2(randf_range(-2, 2), randf_range(-1, 1))
		shake_tween.tween_property(rocket, "position", Vector2(160, STOP_TARGET_Y) + offset, 0.04)
	
	await shake_tween.finished
	_set_particles_emitting(true)
	# 3. Parallel Flight
	var flight_tween = create_tween().set_parallel(true)
	
	# Move world
	var target_y = TARGET_POSITIONS[rarity]
	flight_tween.tween_property(world_container, "position:y", target_y, 4.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Move rocket up
	flight_tween.tween_property(rocket, "position:y", 300.0, 1.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
	# --- BACKGROUND PARALLAX ---
	get_tree().create_timer(3.0).timeout.connect(func(): _set_particles_emitting(false))
	# Move space_bg up (negative Y)
	flight_tween.tween_property(space_bg, "position:y", space_bg.position.y + space_offset, 4.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	# Move stars_bg up (negative Y) at a slower rate
	flight_tween.tween_property(stars_bg, "position:y", stars_bg.position.y + stars_offset, 4.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await flight_tween.finished
	
	# Final Shake at target
	var shake_tween2 = create_tween()
	for i in range(12):
		var offset = Vector2(randf_range(-2, 2), randf_range(-1, 1))
		shake_tween2.tween_property(rocket, "position", Vector2(160, 300) + offset, 0.04)
	await shake_tween2.finished
	_reveal_reward()

func _reveal_reward() -> void:
	if reward_claimed: return
	reward_claimed = true
	
	Game.player_stats.unlock_bullet(predetermined_reward)
	Game.save_stats()
	
	var anim_name := predetermined_reward.to_lower()
	if reward_sprite.sprite_frames.has_animation(anim_name):
		reward_sprite.global_position = rocket.global_position
		reward_sprite.visible = true
		reward_sprite.play(anim_name)
	
	$collect_button.visible = true

func _on_button_pressed() -> void:
	buy_gacha_shot()

func _on_collect_button_pressed() -> void:
	reset_gacha_view()
func _on_leave_button_pressed() -> void:
	if !is_launching:
		visible = false
		position = $"../../asteroid_marker".global_position
func _set_particles_emitting(is_emitting: bool) -> void:
	for p in particle_set:
		if p is CPUParticles2D:
			p.emitting = is_emitting
