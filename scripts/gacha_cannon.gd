extends Node2D

@onready var tube_sprite = $CannonTube
@onready var fire_marker = $CannonTube/Marker2D
@onready var aim_line = $Line2D

@export var bullet_scene = preload("res://scenes/bullet.tscn")
@export var min_speed := 900.0
@export var max_speed := 2000.0
@export var shake_strength := 6.0
@export var shake_time := 0.2

signal gacha_shot_fired
signal gacha_bullet_finished

var min_angle := deg_to_rad(-80)
var max_angle := deg_to_rad(80)

var _original_pos: Vector2
var touching := false
var touch_pos := Vector2.ZERO
var shot_used := false
var disabled = true
func _ready():
	_original_pos = position
	aim_line.clear_points()

# =====================
# INPUT
# =====================
func _unhandled_input(event: InputEvent) -> void:
	if shot_used or disabled:
		return

	if event is InputEventScreenTouch:
		touching = event.pressed
		touch_pos = event.position

		if event.pressed:
			update_aim_line(touch_pos)
		else:
			shoot(touch_pos)
			aim_line.clear_points()

	elif event is InputEventScreenDrag and touching:
		touch_pos = event.position
		update_aim_line(touch_pos)

func _process(_delta: float) -> void:
	if not touching or disabled:
		return

	var dir = touch_pos - tube_sprite.global_position
	var angle = dir.angle() + deg_to_rad(90)
	tube_sprite.rotation = clamp(angle, min_angle, max_angle)

# =====================
# SHOOT
# =====================
func shoot(target_pos: Vector2) -> void:
	if shot_used:
		return

	shot_used = true

	var bullet = bullet_scene.instantiate()
	bullet.global_position = fire_marker.global_position
	get_parent().add_child(bullet)

	# Bullet reports back to this cannon
	bullet.cannon = self

	var dist = fire_marker.global_position.distance_to(target_pos)
	var h = get_viewport_rect().size.y
	var t = clamp(dist / h, 0.0, 1.0)

	var speed = lerp(min_speed, max_speed, t)
	bullet.speed = speed
	bullet.max_speed = speed

	bullet.shoot(tube_sprite.rotation - deg_to_rad(90), 7) # type is irrelevant in gacha

	shake()
	emit_signal("gacha_shot_fired")

# =====================
# BULLET CALLBACK
# =====================
func bullet_stopped(_bullet):
	emit_signal("gacha_bullet_finished")

# =====================
# VISUALS
# =====================
func update_aim_line(target_pos: Vector2) -> void:
	aim_line.clear_points()

	var start = fire_marker.global_position
	var dir = (target_pos - start).normalized()
	var end = start + dir * start.distance_to(target_pos)

	aim_line.add_point(aim_line.to_local(start))
	aim_line.add_point(aim_line.to_local(end))

func shake():
	var tween = create_tween()
	for i in range(6):
		tween.tween_property(
			self,
			"position",
			_original_pos + Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength)
			),
			shake_time / 6
		)
	tween.tween_property(self, "position", _original_pos, shake_time / 6)
