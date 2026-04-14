extends StaticBody2D
enum BrickType {
	RED, PURPLE, YELLOW, GREEN, BLUE, ORANGE_1, ORANGE_2, ENEMY_RED, COIN, BOOSTER, EXP
}
var grid_pos: Vector2i
var brick_type: int

# Called when the node enters the scene tree for the first time.
func is_brick() -> bool:
	return true
