extends CanvasLayer
@onready var ui_top_bar = $ui_top_bar
@onready var pause_menu = $pause_menu
var gameref = null
# Called when the node enters the scene tree for the first time.
func initialize_ui(newgameref):
	gameref = newgameref
	pause_menu.initialize_menu(gameref)
func show_stage_start(bullet_chamber):
	pass
func show_pause_menu():
	pause_menu.visible = true
	
