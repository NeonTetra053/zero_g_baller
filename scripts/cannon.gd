extends Node2D

@onready var tube_sprite = $CannonTube
@onready var fire_marker = $CannonTube/Marker2D
@onready var aim_line = $Line2D
@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var camera_zoom_in: bool = true
@export var max_speed := 2000.0
@export var min_speed := 200.0
@export var shake_strength := 6.0
@export var shake_time := 0.2

@export var bullet_damage = 3
@export var bullet_size_multiplier = 1.0
@export var bullet_speed_multiplier = 1.0
@export var bullet_damp_multiplier = 1.5
@export var x_limit := 20
@onready var camera = $Camera2D # Ensure this exists

var aim_power: int = 1
var min_angle := deg_to_rad(-80)
var max_angle := deg_to_rad(80)
var _original_pos: Vector2
var touch_pos := Vector2.ZERO

var touching := false
var n = 0
var bullet_chamber = [0,0,0,0,0,0] # Keep fixed at 6
var cannon_preset_chamber = [1,0,0,0,0,0]
var blocked = true
var active_bullets := []
var anchored_position

func _ready():
	_original_pos = position

func set_cannon(array = [1,0,0,0,0,0]):
	cannon_preset_chamber = array
	reload()
func reset_cannon():
	var bullet_damage = 3
	var bullet_size_multiplier = 1.0
	var bullet_speed_multiplier = 1.0
	var bullet_damp_multiplier = 1.5
func reload():
	n = 0
	# 1. Reset bullet_chamber to 6 empty slots
	bullet_chamber = [0, 0, 0, 0, 0, 0]
	
	# 2. Get the index of the currently equipped ball from stats
	var equipped_type_name = Game.player_stats.equipped_bullet
	var equipped_index = _get_type_index(equipped_type_name)
	
	# 3. Fill the fixed 6-slot chamber based on the preset
	# If preset has a 1, put the equipped bullet index there.
	for i in range(6):
		if cannon_preset_chamber[i] > 0:
			bullet_chamber[i] = equipped_index
		else:
			bullet_chamber[i] = 0
	
	# 4. Update the visual UI chamber (always receives size 6)
	get_parent().get_parent().chamber.load_bullets(bullet_chamber)
	
	# 5. Set initial line width
	set_line_width(bullet_chamber[0])

# Helper to map String names to BulletType Enum integers
func _get_type_index(id: String) -> int:
	match id.to_upper():
		"BASIC": return 1
		"LIGHT": return 2
		"HEAVY": return 3
		"FROZEN": return 4
		"SHOCK": return 5
		"NANO": return 6
	return 1 # Default to basic if something goes wrong

func _unhandled_input(event: InputEvent) -> void:
	if get_parent().positioning_mode:
		return
		
	if event is InputEventScreenTouch:
		touching = event.pressed
		touch_pos = event.position

		if event.pressed:
			# Only show line if we didn't start the touch in the cancel zone
			if !is_in_cancel_zone(touch_pos):
				update_aim_line(touch_pos)
		else:
			# --- CANCELLATION CHECK ---
			if is_in_cancel_zone(touch_pos):
				print("Shot Cancelled")
			else:
				shoot_bullet(touch_pos)
			
			aim_line.clear_points()

	elif event is InputEventScreenDrag:
		touch_pos = event.position
		# Hide line dynamically if dragging into the cancel zone
		if is_in_cancel_zone(touch_pos):
			aim_line.clear_points()
		else:
			update_aim_line(touch_pos)

func _process(delta: float) -> void:
	if get_parent().positioning_mode:
		return
		
	if touching:
		# Stop the cannon from rotating if we are in the cancel zone
		if is_in_cancel_zone(touch_pos):
			return
			
		var dir = touch_pos - tube_sprite.global_position
		var angle = dir.angle() + deg_to_rad(90)
		tube_sprite.rotation = clamp(angle, min_angle, max_angle)

		update_aim_power()
		$"../CanvasLayer/power_bar".value = aim_power

# New Helper Function
func is_in_cancel_zone(pos: Vector2) -> bool:
	var screen_h = get_viewport_rect().size.y
	var cancel_threshold = screen_h * 0.9 # Bottom 10%
	return pos.y >= cancel_threshold
func update_aim_power() -> void:
	var screen_h := get_viewport_rect().size.y
	var half_y := screen_h * 0.7
	var cannon_y = tube_sprite.global_position.y - 40
	var clamped_touch_y = clamp(touch_pos.y, half_y, cannon_y)
	var t = (cannon_y - clamped_touch_y) / (cannon_y - half_y)
	t = clamp(t, 0.0, 1.0)
	aim_power = int(lerp(1.0, 100.0, t))

func shoot_bullet(target_pos: Vector2) -> void:
	if blocked:
		return

	if bullet_chamber[n] != 0:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = fire_marker.global_position
		get_parent().get_parent().bullets.add_child(bullet)
		
		# --- CAMERA FOLLOW LOGIC ---
		if camera_zoom_in:
			var remote = RemoteTransform2D.new()
			remote.remote_path = camera.get_path()
			bullet.add_child(remote)
			
			var zoom_tween = create_tween()
			zoom_tween.tween_property(camera, "zoom", Vector2(1.5, 1.5), 0.4)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# ---------------------------

		active_bullets.append(bullet)
		bullet.cannon = self
		
		$AnimationPlayer.play("cannon_tube_fire")
		shake()
		get_parent().get_parent().chamber.spin()

		var power_t := float(aim_power) / 100.0
		
		bullet.shoot(
			tube_sprite.rotation - deg_to_rad(90),
			bullet_chamber[n],
			bullet_damage,
			bullet_size_multiplier,
			bullet_speed_multiplier,
			bullet_damp_multiplier,
			power_t
		)
		
		bullet_chamber[n] = 0
		check_chamber_empty()
	else:
		get_parent().get_parent().chamber.spin()
	
	n += 1
	if n > 5: n = 0; blocked = true
	set_line_width(bullet_chamber[n])
func check_chamber_empty():
	if bullet_chamber == [0,0,0,0,0,0]:
		blocked = true

func bullet_stopped(bullet):
	if bullet in active_bullets:
		active_bullets.erase(bullet)
	if get_parent().get_parent().check_victory() != 0:
		return
	if blocked and (!has_live_bullets() or active_bullets.size() == 0):
		await get_tree().create_timer(0.2).timeout
		blocked = false
		get_parent().get_parent().next_turn()
		n = 0
	get_parent().clear_streak()
	_reset_camera()
func _reset_camera():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(camera, "position", Vector2(160, 341), 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2(1, 1), 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
func update_aim_line(target_pos: Vector2) -> void:
	var radius: float = 8.0 * bullet_size_multiplier
	aim_line.clear_points()
	
	var start_pos = fire_marker.global_position
	var mouse_dir = (target_pos - start_pos).normalized()
	if mouse_dir.y > 0: mouse_dir.y *= -1

	var current_pos = start_pos
	var current_dir = mouse_dir
	
	aim_line.add_point(aim_line.to_local(current_pos))
	
	var remaining_length = 1000.0
	var max_bounces = 8
	var space_state = get_world_2d().direct_space_state

	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	
	for i in range(max_bounces + 1):
		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = circle_shape
		query.transform = Transform2D(0, current_pos)
		query.motion = current_dir * remaining_length
		query.collision_mask = 1

		var cast_result = space_state.cast_motion(query)
		var safe_fraction = cast_result[0]
		
		if safe_fraction < 1.0:
			var hit_pos = current_pos + (current_dir * remaining_length * safe_fraction)
			
			var rest_query = PhysicsShapeQueryParameters2D.new()
			rest_query.shape = circle_shape
			rest_query.transform = Transform2D(0, hit_pos + current_dir * 0.5)
			rest_query.collision_mask = query.collision_mask
			
			var rest_info = space_state.get_rest_info(rest_query)
			
			aim_line.add_point(aim_line.to_local(hit_pos))
			
			var dist = current_pos.distance_to(hit_pos)
			remaining_length -= dist
			
			if rest_info.has("normal"):
				var normal = rest_info["normal"]

				if abs(normal.x) > 0.9:
					normal = Vector2(sign(normal.x), 0)
				elif abs(normal.y) > 0.9:
					normal = Vector2(0, sign(normal.y))
				
				current_dir = current_dir.bounce(normal)
				
				current_pos = hit_pos + (normal * 1.0)
			else:
				if hit_pos.x <= (0 + radius + 2) or hit_pos.x >= (320 - radius - 2):
					current_dir.x *= -1
				else:
					current_dir.y *= -1
				current_pos = hit_pos + (current_dir * 1.0)
				
			if remaining_length <= 2.0: break
		else:
			aim_line.add_point(aim_line.to_local(current_pos + current_dir * remaining_length))
			break
func has_live_bullets() -> bool:
	for b in active_bullets:
		if b != null: return true
	return false

func shake():
	if has_meta("shake_tween"):
		var old = get_meta("shake_tween")
		if is_instance_valid(old): old.kill()
	var tween = create_tween()
	set_meta("shake_tween", tween)
	var steps := 6
	var step_time := shake_time / steps
	for i in range(steps):
		var offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		tween.tween_property(self, "position", _original_pos + offset, step_time)
	tween.tween_property(self, "position", _original_pos, step_time)

func set_line_width(type):
	pass

func set_cannon_position():
	position = anchored_position
	_original_pos = position

func add_buff(id: String):
	match id:
		"larger_barrel":
			bullet_size_multiplier += 0.1
			bullet_damp_multiplier -= 0.03 # Decrease damp Aby 4%
			print("Buff Added: Larger Barrel")
			
		"smaller_barrel":
			bullet_size_multiplier -= 0.10
			bullet_speed_multiplier += 0.03 # Increase speed by 4%
			print("Buff Added: Smaller Barrel")
			
		"enhanced_coating":
			bullet_damp_multiplier -= 0.05 # Decrease damp by 12%
			print("Buff Added: Enhanced Coating")
			
		"firepower":
			bullet_speed_multiplier += 0.05 # Increase speed by 12%
			print("Buff Added: Firepower")
		"range_plus":
			x_limit = min(x_limit+10, 120)
		"extra_damage":
			bullet_damage += 1
	set_line_width(bullet_chamber[n])
