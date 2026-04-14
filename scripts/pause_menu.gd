extends Control
var gameref = null
func initialize_menu(newgameref):
	gameref = newgameref



func _on_button_pressed() -> void:
	gameref.unpause_game()
	visible = false

func _on_button_3_pressed() -> void:
	if gameref:
		gameref.return_to_main_menu()
		visible = false
