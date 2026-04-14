extends StaticBody2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_GREEN, COIN, BOOSTER, EXP, ENEMY_YELLOW, ENEMY_RED
}
@export var hp: float = 1
@export var step: int = 2
@onready var sprite = $sprite

@export var sway_amplitude := Vector2(2.0, 1.0)
@export var sway_speed := 2.0
@export var sway_rotation := 0.05
var grid_pos: Vector2
@export var brick_type: BrickType= BrickType.ENEMY_GREEN
var sway_time := 0.0
var current_hp: float = 0

func is_enemy() -> bool:
	return true
	

func set_hp(value):
	hp = value
	current_hp = hp
	$sprite/Label.text = str(int(current_hp))
	

func _ready() -> void:
	current_hp = hp
	$sprite/Label.text = str(int(current_hp))
	$AnimationPlayer.play("appear")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		body.impact()
		hit(1)

func die():
	$CollisionShape2D.disabled = true
	$CollisionShape2D.queue_free()
	for i in range(3):
		var coin_scene = preload("res://scenes/visual_coin.tscn")
		var coin = coin_scene.instantiate()
		coin.global_position = self.global_position
		# Add to the very top of the scene tree so it persists
		get_tree().root.add_child(coin)
		
		# Start them exactly where the enemy died
		
	$sprite.play("explode")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func hit(amount: int):
	if current_hp > 0:
		get_parent().count_hit(1)
		$CPUParticles2D.emitting = true
		current_hp -= amount
		if current_hp <=0:
			die()
		$sprite/Label.text = str(int(current_hp))
		$ProgressBar.value = 100*(current_hp/hp)
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
