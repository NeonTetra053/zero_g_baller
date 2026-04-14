extends StaticBody2D

@export var gravity_strength: float = 500.0
@export var radius: float = 140
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_GREEN, COIN, BOOSTER, EXP, ENEMY_YELLOW, ENEMY_RED, PLANET
}
var grid_pos: Vector2i
var brick_type: int

var bullets_in_area: Array = []

func _physics_process(delta: float) -> void:
	for bullet in bullets_in_area:
		if not is_instance_valid(bullet):
			continue
		if not bullet is RigidBody2D:
			continue

		var direction = global_position - bullet.global_position
		var distance = direction.length()
		if distance == 0 or distance > radius:
			continue

		var force_dir = direction / distance
		var force = force_dir * gravity_strength * bullet.mass
		bullet.apply_central_force(force)

		# Stop the bullet if it's close enough and moving very slowly
		if distance < 40 and bullet.linear_velocity.length() < 10:
			bullet.linear_velocity = Vector2.ZERO
			bullet.angular_velocity = 0
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		if body not in bullets_in_area:
			bullets_in_area.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bullets_in_area:
		bullets_in_area.erase(body)
