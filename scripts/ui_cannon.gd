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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		touching = event.pressed
		touch_pos = event.position

	elif event is InputEventScreenDrag:
		touch_pos = event.position

func _process(delta: float) -> void:
	if not touching:
		return

	var dir = touch_pos - tube_sprite.global_position
	var angle = dir.angle() + deg_to_rad(90)
	tube_sprite.rotation = clamp(angle, min_angle, max_angle)
