extends RigidBody2D
enum BulletType {
	NONE,
	BASIC,
	LIGHT,
	HEAVY,
	FROZEN,
	SHOCK,
	NANO,
	GACHA
}
var bullet_types = [BulletType.NONE, BulletType.BASIC, BulletType.LIGHT, BulletType.HEAVY, BulletType.FROZEN, BulletType.SHOCK, BulletType.NANO, BulletType.GACHA]
@onready var sprite = $sprite
@onready var collision_shape = $CollisionShape2D
@export var bullet_type: BulletType = BulletType.BASIC
@export var speed: float = 400.0           # Default, can be overridden
@export var max_speed: float = 400.0           # Default, can be overridden
var boost: float = 1
var cannon: Node = null
var stopped_called := false  # Track if bullet_stopped() was already called
var stop_threshold := 6.0    

var last_move_dir := Vector2.ZERO
var shock_aftershock_used := false
func _ready() -> void:
	gravity_scale = 0  # Ignore gravity

func apply_bullet_effects() -> void:
	match bullet_type:
		BulletType.BASIC:
			sprite.play("basic")
			speed *= 2
			linear_damp = 1.
			collision_shape.scale = Vector2(1.3, 1.3)
			$CPUParticles2D2.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
			$CPUParticles2D2.emitting = true
		BulletType.LIGHT:
			speed *= 2.5
			sprite.play("light")
			linear_damp = 1.
			collision_shape.scale = Vector2(0.9, 0.9)
			mass = 0.5
			$CPUParticles2D2.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
			$CPUParticles2D2.emitting = true
		BulletType.HEAVY:
			speed *= 1.4
			sprite.play("heavy")
			collision_shape.scale = Vector2(1.5, 1.5)
			mass = 5
			linear_damp = 1.5
			

		BulletType.FROZEN:
			speed *= 1.2
			linear_damp = 1.3
			sprite.play("icy")
			collision_shape.scale = Vector2(1.3, 1.3)
			$CPUParticles2D.emitting = true
		BulletType.SHOCK:
			speed *= 2.5
			linear_damp = 2
			mass = 4
			sprite.play("shock")
			collision_shape.scale = Vector2(0.9, 0.9)
		BulletType.NANO:
			speed *= 0.7
			linear_damp = 1
			mass = 0.1
			sprite.play("nano")
			collision_shape.scale = Vector2(0.35, 0.35)
			$nano_paticle.emitting = true
		BulletType.GACHA:
			sprite.play("basic")
			speed *= 1
			linear_damp = 0.0
			collision_shape.scale = Vector2(1.3, 1.3)
			$CPUParticles2D2.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
			$CPUParticles2D2.emitting = true
	# default damp for all non-frozen bullets
func shoot(angle: float, type:int) -> void:
	rotation = angle
	bullet_type = bullet_types[type]
	apply_bullet_effects()
	# IMPORTANT: use the current `speed` property at this moment
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed * boost
	

func _physics_process(_delta):
	# Clamp max speed
	if !freeze and !sleeping:
		if linear_velocity.length() > max_speed * boost:
			linear_velocity = linear_velocity.normalized() * max_speed * boost

		# Remember last real movement direction
		if linear_velocity.length() > 5.0:
			last_move_dir = linear_velocity.normalized()

		# Stop detection
		if linear_velocity.length() < stop_threshold:
			linear_velocity = Vector2.ZERO

			if not stopped_called:
				stopped_called = true
				bullet_stopped()
func boost_bullet(value):
	boost = value 
	linear_velocity = linear_velocity + (last_move_dir * max_speed * 0.3)
func _on_timer_timeout() -> void:
	queue_free()

func is_bullet():
	pass
func bullet_stopped():
	# SHOCK aftershock
	if bullet_type == BulletType.SHOCK and not shock_aftershock_used:
		shock_aftershock_used = true
		stopped_called = false
		sleeping = false

		# Push in the last movement direction
		linear_velocity = last_move_dir * max_speed * boost * 0.3
		return

	if cannon:
		cannon.bullet_stopped(self)
