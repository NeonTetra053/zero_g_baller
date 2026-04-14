extends RigidBody2D
class_name bullet
enum BulletType {
	NONE,
	BASIC,
	LIGHT,
	HEAVY,
	FROZEN,
	SHOCK,
	NANO,
	GACHA,
	FIRE
}
var bullet_types = [BulletType.NONE, BulletType.BASIC, BulletType.LIGHT, BulletType.HEAVY, BulletType.FROZEN, BulletType.SHOCK, BulletType.NANO, BulletType.GACHA, BulletType.FIRE]
@onready var sprite = $sprite
@onready var collision_shape = $CollisionShape2D
@export var bullet_type: BulletType = BulletType.BASIC
@export var speed: float = 800.0           # Default, can be overridden
@export var max_speed: float = 2000.0           # Default, can be overridden
@onready var impact_particles = $CPUParticles2D4
@export var scale_multiplier: float = 0.8

var multiplier_size: float = 1.0
var multiplier_speed: float = 1.0
var multiplier_damp: float = 1.0
var damage: int = 3

var boost: float = 1
var mod_scale: float = 1
var cannon: Node = null
var stopped_called := false  # Track if bullet_stopped() was already called
var stop_threshold := 10.0    # Consider stopped if speed < this value

var last_move_dir := Vector2.ZERO
var shock_aftershock_used := false
func _ready() -> void:
	gravity_scale = 0  # Ignore gravity

var base_collision_ratio: float = 1.0 

func increase_scale(val: float):
	scale_multiplier += val
	
	sprite.scale = Vector2(scale_multiplier, scale_multiplier)
	
	collision_shape.scale = Vector2(base_collision_ratio, base_collision_ratio) * scale_multiplier
	
	print("Bullet grew! Current scale multiplier: ", scale_multiplier)
func apply_bullet_effects() -> void:
	var stats = Game.player_stats

	var current_base_ratio : float = 1.0

	match bullet_type:
		BulletType.BASIC:
			sprite.play("basic")
			var propulsion = stats.get_upgrade_level("BASIC", "Propulsion")
			var stability = stats.get_upgrade_level("BASIC", "Stability")
			var density = stats.get_upgrade_level("BASIC", "Density")
			
			speed *= (2.0 + (propulsion * 0.2))
			linear_damp = 1.7 - (stability * 0.2)
			mass = 1.0 + (density * 0.5)
			current_base_ratio = 1.3

		BulletType.LIGHT:
			sprite.play("light")
			var velocity = stats.get_upgrade_level("LIGHT", "Velocity")
			var aero = stats.get_upgrade_level("LIGHT", "Aerodynamics")
			var modulation = stats.get_upgrade_level("LIGHT", "Modulation")
			
			speed *= (2.5 + (velocity * 0.3))
			linear_damp = 1.7 - (aero * 0.2)
			boost *= (1.0 + (modulation * 0.1)) 
			mass = 0.5
			current_base_ratio = 0.9

		BulletType.HEAVY:
			sprite.play("heavy")
			var compression = stats.get_upgrade_level("HEAVY", "Compression")
			var impact_damp = stats.get_upgrade_level("HEAVY", "Impact Damp")
			
			speed *= 1.4
			mass = 5.0 + (compression * 1.5)
			linear_damp = 1.9 - (impact_damp * 0.2)
			current_base_ratio = 1.5

		BulletType.FROZEN:
			sprite.play("icy")
			var snow_coat = stats.get_upgrade_level("FROZEN", "Snow Coat")
			var condensed_ice = stats.get_upgrade_level("FROZEN", "Condensed Ice")
			var smoothness = stats.get_upgrade_level("FROZEN", "Smoothness")
			
			speed *= (1.2 + (snow_coat * 0.15))
			mass = 1.0 + (condensed_ice * 0.4)
			linear_damp = 1.5 - (smoothness * 0.2)
			current_base_ratio = 1.3
			$CPUParticles2D.emitting = true

		BulletType.SHOCK:
			sprite.play("shock")
			var efficiency = stats.get_upgrade_level("SHOCK", "Efficiency")
			
			speed *= 2.5
			linear_damp = 2.2 - (efficiency * 0.2)
			mass = 4.0
			current_base_ratio = 0.9

		BulletType.NANO:
			sprite.play("nano")
			var coherence = stats.get_upgrade_level("NANO", "coherence")
			var density = stats.get_upgrade_level("NANO", "density")
			
			speed *= (0.7 + (coherence * 0.1))
			mass = 0.1 + (density * 0.05)
			linear_damp = 1.0
			current_base_ratio = 0.35
			$nano_paticle.emitting = true

		BulletType.FIRE:
			sprite.play("fire")
			var propulsion = stats.get_upgrade_level("BASIC", "Propulsion")
			var stability = stats.get_upgrade_level("BASIC", "Stability")
			var density = stats.get_upgrade_level("BASIC", "Density")
			
			speed *= (1.5 + (propulsion * 0.2))
			linear_damp = 2.0 - (stability * 0.2)
			mass = 3.0 + (density * 0.5)
			current_base_ratio = 1.3
			damage = 1

	speed *= multiplier_speed
	linear_damp *= multiplier_damp
	scale_multiplier *= multiplier_size
	mass *= multiplier_size 

	sprite.scale = Vector2(current_base_ratio, current_base_ratio) * scale_multiplier
	collision_shape.scale = Vector2(current_base_ratio, current_base_ratio) * scale_multiplier

	if has_node("CPUParticles2D2") and sprite.animation != "nano":
		$CPUParticles2D2.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
		$CPUParticles2D2.emitting = true
func shoot(angle: float, type: int, p_damage: int, p_size: float, p_speed: float, p_damp: float, p_power: float) -> void:
	rotation = angle
	bullet_type = bullet_types[type]
	
	self.damage = p_damage
	self.multiplier_size = p_size
	self.multiplier_speed = p_speed
	self.multiplier_damp = p_damp
	
	apply_bullet_effects()
	

	speed *= p_power 
	
	max_speed = max(max_speed, speed) * multiplier_speed
	
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed * boost
	
	print("Shot Type: ", BulletType.keys()[bullet_type], " Speed: ", linear_velocity.length())
func _physics_process(_delta):
	if !freeze and !sleeping:
		if linear_velocity.length() > max_speed * boost:
			linear_velocity = linear_velocity.normalized() * max_speed * boost

		if linear_velocity.length() > 5.0:
			last_move_dir = linear_velocity.normalized()

		if linear_velocity.length() < stop_threshold:
			linear_velocity = Vector2.ZERO

			if not stopped_called:
				stopped_called = true
				bullet_stopped()
func boost_bullet(value):
	boost = value 
	linear_velocity *= boost
func _on_timer_timeout() -> void:
	queue_free()

func is_bullet():
	pass
func bullet_stopped():
	var stats = Game.player_stats
	
	if bullet_type == BulletType.SHOCK and not shock_aftershock_used:
		shock_aftershock_used = true
		stopped_called = false
		sleeping = false

		# Capacitor: Increases aftershock power
		var capacitor = stats.get_upgrade_level("SHOCK", "Capacitor")
		# Alignment: Improves directional control (less speed loss)
		var alignment = stats.get_upgrade_level("SHOCK", "Alignment")
		
		var power_mult = 0.3 + (capacitor * 0.1)
		var alignment_bonus = 1.0 + (alignment * 0.1)

		linear_velocity = last_move_dir * max_speed * boost * power_mult * alignment_bonus
		return

	if cannon:
		cannon.bullet_stopped(self)
var _teleport_position: Vector2
var _must_teleport := false

func teleport_to(pos: Vector2) -> void:
	_must_teleport = true
	_teleport_position = pos


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _must_teleport:
		_must_teleport = false

		state.transform.origin = _teleport_position

		state.sleeping = false
func impact() -> void:
	if impact_particles:
		var move_dir = linear_velocity.normalized()
		
		if move_dir == Vector2.ZERO:
			move_dir = last_move_dir
		
		var opposite_dir = -move_dir
		
		impact_particles.direction = opposite_dir
		
		impact_particles.restart()
		impact_particles.emitting = true
	if bullet_type == BulletType.FIRE:
		var scene = preload("res://scenes/area_particle.tscn").instantiate()
		get_parent().add_child(scene)
		scene.position = self.global_position

func is_fire():
	return bullet_type == BulletType.FIRE

func force_stop():
	shock_aftershock_used = true
	stopped_called = false
	sleeping = false
