extends StaticBody2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_RED, COIN, BOOSTER, EXP
}
@export var hp: float = 2
@export var step: int = 2
@onready var sprite = $sprite

@export var sway_amplitude := Vector2(1.2, 0.6)
@export var sway_speed := 2.0
@export var sway_rotation := 0.03
@onready var light_sprite = $sprite/Light
@onready var particles = $CPUParticles2D
@onready var label = $sprite/Label
var grid_pos: Vector2
var brick_type = BrickType.ENEMY_RED

func is_enemy() -> bool:
	return true
var sway_time := 0.0
var current_hp: float = 0
func set_hp(value):
	hp = value
	current_hp = hp
	$sprite/Label.text = str(int(current_hp))
func _ready() -> void:
	current_hp = hp
	$sprite/Label.text = str(int(current_hp))
	$AnimationPlayer.play("appear")
	
	# FIX: Make the LabelSettings unique to this specific instance
	if label.label_settings:
		label.label_settings = label.label_settings.duplicate()
	
	# Randomly pick an index between 0 and 2
	var random_type = randi() % 3
	
	match random_type:
		0:
			sprite.play("square_yellow")
			light_sprite.modulate = Color(1.0, 1.0, 0.2, 0.447)
			particles.color = Color(1.0, 1.0, 0.2, 1.0)
			label.label_settings.font_color = Color(0.758, 0.411, 0.0, 1.0)
		1:
			sprite.play("square_magenta")
			light_sprite.modulate = Color(1.0, 0.47, 0.991, 0.463)
			particles.color = Color(1.0, 0.47, 0.991, 1.0) 
			label.label_settings.font_color = Color(0.537, 0.0, 0.539, 1.0) 
		2:
			sprite.play("square_purple")
			light_sprite.modulate = Color(0.55, 0.49, 1.0, 0.522)
			particles.color = Color(0.55, 0.49, 1.0, 1.0)
			label.label_settings.font_color = Color(0.291, 0.001, 0.745, 1.0)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
#body.increase_scale(0.2)
		body.impact()
		if !body.is_fire():
			hit(body.damage)
		
	if body.has_method("is_projectile"):
		hit(1)
	if body.has_method("is_star"):
		hit(body.star_damage)
func die():
	# 1. Disable collisions so it doesn't get hit while exploding
	$CollisionShape2D.set_deferred("disabled", true)
	
	# 2. 50% Chance to spawn a coin
	if randf() < 0.5:
		spawn_coin()
	
	# 3. Play explosion and clean up
	$sprite.play("explode")
	await get_tree().create_timer(1).timeout
	queue_free()

func spawn_coin():
	# Make sure the path to your coin scene is correct!
	var coin_scene = preload("res://scenes/visual_coin.tscn")
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	# Add to root so it stays alive after the enemy is freed
	get_tree().root.add_child(coin)
	
	# Start at this enemy's current position
	

func hit(amount: int):
	if current_hp > 0:
		get_parent().count_hit(1)
		$CPUParticles2D.emitting = true
		current_hp -= amount
		$sprite/Label.text = str(int(current_hp))
		if current_hp <=0:
			$sprite/Label.visible = false
			die()
			
		position = position + Vector2(3, 0)
		await get_tree().create_timer(0.05).timeout
		position = position + Vector2(-5, 0)
		await get_tree().create_timer(0.05).timeout
		position = position + Vector2(4, 0)
		await get_tree().create_timer(0.05).timeout
		position = position + Vector2(-3, 0)
		await get_tree().create_timer(0.05).timeout
		position = position + Vector2(2, 0)
		await get_tree().create_timer(0.05).timeout
		position = position + Vector2(-1, 0)
func _process(delta: float) -> void:
	sway_time += delta * sway_speed

	# Figure-8 motion
	var x = sin(sway_time) * sway_amplitude.x
	var y = sin(sway_time * 2.0) * sway_amplitude.y

	sprite.position = Vector2(x, y)

	# Gentle tilt
	sprite.rotation = sin(sway_time) * sway_rotation
func attack():
	get_parent().reduce_hp(1)
	var scene = preload("res://scenes/enemy_bullet.tscn").instantiate()
	add_child(scene)
