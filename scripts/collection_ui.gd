extends Control
@onready var collection_ui = $collection_ui
@onready var bullet_detail = $bullet_detail
const BALLS_PER_PAGE := 6

var balls = [
	{ "id": "BASIC",  "name": "Standard Bullet", "anim": "basic" },
	{ "id": "LIGHT",  "name": "Light Bullet",    "anim": "light" },
	{ "id": "HEAVY",  "name": "Heavy Bullet",    "anim": "heavy" },
	{ "id": "FROZEN", "name": "Frozen Bullet",   "anim": "icy" },
	{ "id": "SHOCK",  "name": "Shock Bullet",    "anim": "shock" },
	{ "id": "NANO",   "name": "Nano Shot",       "anim": "nano" },
]
var unlocked_balls: Array = []
var current_page := 0

@onready var ball_sprites = [
	$collection_ui/sprite, $collection_ui/sprite2, $collection_ui/sprite3, $collection_ui/sprite4, $collection_ui/sprite5, $collection_ui/sprite6
]

@onready var name_labels = [
	$collection_ui/Label, $collection_ui/Label2, $collection_ui/Label3, $collection_ui/Label4, $collection_ui/Label5, $collection_ui/Label6
]

func _ready() -> void:
	bullet_detail.visible = false
	_refresh_unlocked_balls()
	update_page()
func _refresh_unlocked_balls() -> void:
	unlocked_balls.clear()

	for ball in balls:
		if Game.player_stats.is_bullet_unlocked(ball.id):
			unlocked_balls.append(ball)

	# clamp page in case unlock count changed
	current_page = min(
		current_page,
		max(ceil(float(unlocked_balls.size()) / BALLS_PER_PAGE) - 1, 0)
	)
func update_page() -> void:
	var start_index = current_page * BALLS_PER_PAGE

	for i in BALLS_PER_PAGE:
		var data_index = start_index + i

		if data_index < unlocked_balls.size():
			var ball = unlocked_balls[data_index]

			ball_sprites[i].visible = true
			name_labels[i].visible = true

			ball_sprites[i].play(ball.anim)
			name_labels[i].text = ball.name
		else:
			ball_sprites[i].visible = false
			name_labels[i].visible = false
func next_page():
	var max_page = ceil(float(unlocked_balls.size()) / BALLS_PER_PAGE) - 1
	current_page = min(current_page + 1, max_page)
	update_page()

func prev_page():
	current_page = max(current_page - 1, 0)
	update_page()


func _on_button_pressed():    on_ball_pressed(0)
func _on_button_2_pressed():  on_ball_pressed(1)
func _on_button_3_pressed():  on_ball_pressed(2)
func _on_button_4_pressed():  on_ball_pressed(3)
func _on_button_5_pressed():  on_ball_pressed(4)
func _on_button_6_pressed():  on_ball_pressed(5)

func on_ball_pressed(slot_index: int) -> void:
	var global_index = current_page * BALLS_PER_PAGE + slot_index

	if global_index >= unlocked_balls.size():
		return

	var bullet_id = unlocked_balls[global_index].id

	bullet_detail.visible = true
	bullet_detail.show_bullet(bullet_id)
	bullet_detail.show_upgrades(bullet_id)


func _on_button_7_pressed() -> void:
	visible = false
