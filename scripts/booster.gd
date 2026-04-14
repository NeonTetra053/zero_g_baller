extends Node2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_GREEN, COIN, BOOSTER, EXP, ENEMY_YELLOW, ENEMY_RED, PLANET
}
var grid_pos: Vector2i
var brick_type: int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_bullet"):
		# Add to global money
		body.boost_bullet(1.3)
		
@export var hover_height: float = 6.0   # pixels
@export var hover_speed: float = 2.0    # speed of the hover

var _time := 0.0
var _start_pos: Vector2

func _ready() -> void:
	_start_pos = $Booster.position

func _process(delta: float) -> void:
	_time += delta * hover_speed
	$Booster.position.y = _start_pos.y + sin(_time) * hover_height
