extends Node2D

@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D

@export var star_damage = 5
@export var speed = 800.0

var velocity := Vector2.ZERO

func _ready() -> void:
	# 90 degrees is Down. Adding 30 degrees moves it "Left-Down"
	var movement_angle = deg_to_rad(90 + 30)
	
	# Create a direction vector from the angle
	velocity = Vector2.RIGHT.rotated(movement_angle) * speed
	
	# Point the star (and particles) in the direction of travel

func _process(delta: float) -> void:
	# Constant movement
	position += velocity * delta
	
	# Keep the spinning visual effect
	sprite.rotation_degrees += 5

func is_star():
	pass

# Clean up when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
