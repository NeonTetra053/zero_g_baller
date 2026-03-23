extends StaticBody2D
@export var hp: float = 2
@export var step: int = 2
@onready var sprite = $sprite

var current_hp: float = 0
func _ready() -> void:
	current_hp = hp
	$ProgressBar.value = 100
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		hit(1)
		if current_hp <=0:
			die()

func die():
	$CollisionShape2D.disabled = true
	$sprite.play("explode")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func hit(amount: int):
	current_hp -= amount
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

func is_enemy():
	pass
func attack():
	Game.reduce_hp(1)
	var scene = preload("res://scenes/enemy_bullet.tscn").instantiate()
	add_child(scene)
