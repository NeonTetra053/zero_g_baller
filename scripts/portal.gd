extends Node2D

@onready var p1_sprite = $portal_1/AnimatedSprite2D
@onready var p2_sprite = $portal_2/AnimatedSprite2D
@onready var timer = $Timer

var portal_locked := false


func _ready():
	timer.wait_time = 0.1
	timer.one_shot = true


func _process(delta: float) -> void:
	p1_sprite.rotation_degrees += 0.7
	p2_sprite.rotation_degrees += 0.7


func _on_portal_1_area_body_entered(body: Node2D) -> void:
	if !portal_locked:
		if body.has_method("is_bullet"):
			teleport(body, $portal_2.global_position)


func _on_portal_2_area_body_entered(body: Node2D) -> void:
	if !portal_locked:
		if body.has_method("is_bullet"):
			teleport(body, $portal_1.global_position)


func teleport(body: RigidBody2D, target_pos: Vector2) -> void:
	portal_locked = true
	print("teleported")

	body.teleport_to(target_pos)

	timer.start()
	
func set_exit_portal_position(pos: Vector2):
	$portal_2.position = pos

func _on_timer_timeout() -> void:
	portal_locked = false
