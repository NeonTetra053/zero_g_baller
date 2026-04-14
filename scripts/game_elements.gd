extends Node2D
@onready var cannon = $cannon
@onready var chamber = $chamber
@onready var hp_bar = $CanvasLayer/hp_bar
@onready var level = $level
@onready var endless = $endless_mode
var power_bar_visible = true
var hit_streak = 0

# Positioning variables
var positioning_mode := false
var permanent_home_pos : Vector2 # This NEVER changes after _ready
var session_start_pos : Vector2   # This is for the "Cancel" button
var x_limit := 40.0

func _ready() -> void:
	# Capture the absolute center of the screen/track once and for all
	permanent_home_pos = cannon.position


func _unhandled_input(event: InputEvent) -> void:
	if positioning_mode:
		if event is InputEventScreenTouch or event is InputEventScreenDrag:
			# Use permanent_home_pos for the clamp boundaries
			var min_x = permanent_home_pos.x - x_limit
			var max_x = permanent_home_pos.x + x_limit
			
			cannon.position.x = clamp(event.position.x, min_x, max_x)

func _on_cannon_pos_button_pressed() -> void:
	x_limit = cannon.x_limit
	positioning_mode = true
	# Save where the cannon is RIGHT NOW so Cancel can return it here
	session_start_pos = cannon.position
	$CanvasLayer/Line2D/mass_label.text = "range: " + str(x_limit)
	$CanvasLayer/Line2D.visible = true
	$CanvasLayer/line_min.visible = true
	$CanvasLayer/line_max.visible = true
	$CanvasLayer/Line2D.points[0] = Vector2(-x_limit, 0)
	$CanvasLayer/Line2D.points[1] = Vector2(x_limit, 0)
	$CanvasLayer/line_min.position = Vector2(160 - x_limit, 646)
	$CanvasLayer/line_max.position = Vector2(160 + x_limit, 646)
	$CanvasLayer/cannon_pos_button.visible = false
	$CanvasLayer/pos_confirm_button.visible = true
	$CanvasLayer/pos_cancel_button.visible = true
	cannon.blocked = true

func _on_pos_confirm_button_pressed() -> void:
	positioning_mode = false
	
	# Update the cannon's internal anchor for its shake logic
	if cannon.has_method("set_cannon_position"):
		cannon.anchored_position = cannon.position
		cannon.set_cannon_position()
	
	_exit_positioning_ui()

func _on_pos_cancel_button_pressed() -> void:
	# Return to where it was when we pressed the "Move" button this time
	cannon.position = session_start_pos
	positioning_mode = false
	_exit_positioning_ui()

func _exit_positioning_ui():
	$CanvasLayer/Line2D.visible = false
	$CanvasLayer/line_min.visible = false
	$CanvasLayer/line_max.visible = false
	$CanvasLayer/cannon_pos_button.visible = true
	$CanvasLayer/pos_confirm_button.visible = false
	$CanvasLayer/pos_cancel_button.visible = false
	cannon.blocked = false

func _on_button_pressed() -> void:
	power_bar_visible = !power_bar_visible
	$CanvasLayer/power_bar.visible = power_bar_visible
	if power_bar_visible:
		$CanvasLayer/Button/AnimatedSprite2D.play("on")
	else:
		$CanvasLayer/Button/AnimatedSprite2D.play("off")
	
func clear_streak():
	$CanvasLayer/hits_label.visible = false
	hit_streak = 0
func add_streak(amount):
	hit_streak += amount
	$CanvasLayer/hits_label.visible = true
	$CanvasLayer/hits_label.text = str(hit_streak) + " HITS!"
	
	# 1. Handle Scaling
	# remap(value, istart, istop, ostart, ostop)
	# This maps hit_streak 1-12 to scale 0.7-1.4
	var target_scale = remap(clamp(hit_streak, 1, 12), 1, 12, 1.1, 1.6)
	$CanvasLayer/hits_label.scale = Vector2(target_scale, target_scale)
	
	# 2. Handle Color Gradient
	$CanvasLayer/hits_label.modulate = get_streak_color(hit_streak)
	
	# 3. Optional: Add a small punch animation
	var tween = create_tween()
	tween.tween_property($CanvasLayer/hits_label, "scale", Vector2(target_scale + 0.1, target_scale + 0.1), 0.05)
	tween.tween_property($CanvasLayer/hits_label, "scale", Vector2(target_scale, target_scale), 0.05)

func get_streak_color(streak: int) -> Color:
	# Define our color steps
	var colors = [
		Color.DEEP_SKY_BLUE, # Blue
		Color.GREEN,         # Green
		Color.YELLOW,        # Yellow
		Color.ORANGE,        # Orange
		Color.RED,           # Red
		Color.MAGENTA        # Magenta
	]
	
	if streak <= 1: return colors[0]
	if streak >= 12: return colors[5]
	
	# Calculate where we are in the gradient (0.0 to 1.0)
	var t = float(streak - 1) / float(12 - 1)
	
	# Find which two colors to interpolate between
	var segment_size = 1.0 / (colors.size() - 1)
	var index = int(t / segment_size)
	var local_t = (t - (index * segment_size)) / segment_size
	
	# Safety check for index
	index = clamp(index, 0, colors.size() - 2)
	
	return colors[index].lerp(colors[index + 1], local_t)
