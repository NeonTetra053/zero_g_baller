extends Node2D

@onready var tube_sprite = $CannonTube
@onready var fire_marker = $CannonTube/Marker2D
@onready var aim_line = $Line2D
@export var bullet_scene = preload("res://scenes/bullet.tscn")

@export var max_speed := 2000.0
@export var min_speed := 900.0
@export var shake_strength := 6.0
@export var shake_time := 0.2


var min_angle := deg_to_rad(-80)
var max_angle := deg_to_rad(80)
var _original_pos: Vector2
var touch_pos := Vector2.ZERO

var touching := false
var n = 0
var bullet_chamber = [1,1,1,1,0,0]
var blocked = true
var active_bullets := []
var anchored_position
func _ready():
	_original_pos = position
func set_cannon():
	n = 0
	bullet_chamber = [1,2,1,2,0,0]
	get_parent().get_parent().chamber.load_bullets(bullet_chamber)
	set_line_width(bullet_chamber[0])
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		touching = event.pressed
		touch_pos = event.position

		if event.pressed:
			update_aim_line(touch_pos)
		else:
			shoot_bullet(touch_pos)
			aim_line.clear_points()

	elif event is InputEventScreenDrag:
		touch_pos = event.position
		update_aim_line(touch_pos)

func _process(delta: float) -> void:
	var dir = touch_pos - tube_sprite.global_position
	var angle = dir.angle() + deg_to_rad(90)
	tube_sprite.rotation = clamp(angle, min_angle, max_angle)

func shoot_bullet(target_pos: Vector2) -> void:
	
	if blocked:
		return

	if bullet_chamber[n] != 0:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = fire_marker.global_position
		get_parent().get_parent().bullets.add_child(bullet)
		
		# Track bullet in active list
		active_bullets.append(bullet)
		
		# Give the bullet a reference to the cannon so it can notify when it stops
		bullet.cannon = self
		
		$AnimationPlayer.play("cannon_tube_fire")
		shake()
		get_parent().get_parent().chamber.spin()
		
		var dist = tube_sprite.global_position.distance_to(target_pos)
		var h = get_viewport_rect().size.y
		var t = clamp(dist / h, 0.0, 1.0)
		bullet.max_speed = lerp(min_speed, max_speed, t)
		bullet.speed = lerp(min_speed, max_speed, t)
		bullet.shoot(tube_sprite.rotation - deg_to_rad(90), bullet_chamber[n])
		
		bullet_chamber[n] = 0
		check_chamber_empty()
	else:
		get_parent().get_parent().chamber.spin()
	
	n += 1

	if n > 5:
		n = 0
	set_line_width(bullet_chamber[n])
func check_chamber_empty():
	# If all bullets are shot, we don’t immediately end the turn
	if bullet_chamber == [0,0,0,0,0,0]:
		# block further shooting
		blocked = true
		# turn will end only when all bullets have stopped
func check_turn_end():
	if bullet_chamber == [0, 0, 0, 0, 0, 0]:
		blocked = true
		await get_tree().create_timer(0.5).timeout
		blocked = false
		get_parent().get_parent().next_turn()
		n = 0
func update_aim_line(target_pos: Vector2) -> void:
	aim_line.clear_points()

	var start_global = fire_marker.global_position
	var dir = (target_pos - start_global).normalized()

	var distance = start_global.distance_to(target_pos)
	var screen_height = get_viewport_rect().size.y
	var strength = clamp(distance / screen_height, 0.0, 1.0)

	var length = distance
	var end_global = start_global + dir * length

	var start_local = aim_line.to_local(start_global)
	var end_local = aim_line.to_local(end_global)

	aim_line.add_point(start_local)
	aim_line.add_point(end_local)
func has_live_bullets() -> bool:
	for b in active_bullets:
		if b!= null:
			return true
	return false
func bullet_stopped(bullet):
	get_parent().get_parent().check_victory()
	if bullet in active_bullets:
		active_bullets.erase(bullet)
	
	if blocked and (!has_live_bullets() or active_bullets.size() == 0):
		# small delay to give the player a visual pause
		await get_tree().create_timer(0.2).timeout
		blocked = false
		get_parent().get_parent().next_turn()
		# Reset chamber for next turn
		set_cannon()
		n = 0
func shake():
	if has_meta("shake_tween"):
		var old = get_meta("shake_tween")
		if is_instance_valid(old):
			old.kill()

	var tween = create_tween()
	set_meta("shake_tween", tween)

	var steps := 6  # how many jitters
	var step_time := shake_time / steps

	for i in range(steps):
		var offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		tween.tween_property(
			self,
			"position",
			_original_pos + offset,
			step_time
		)

	# Return to original position
	tween.tween_property(
		self,
		"position",
		_original_pos,
		step_time
	)
func set_line_width(type):
	match type:
		1:
			$Line2D.width = 11
		2:
			$Line2D.width = 8
		3:
			$Line2D.width = 15
		4:
			$Line2D.width = 11
func set_cannon_position():
	position = anchored_position
	_original_pos = position
