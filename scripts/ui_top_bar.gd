extends Control


func set_coin_amount(n: int):
	$Label.text = str(n)

func set_level_label(n: int):
	$Label2.text = "STAGE " + str(n)
func set_level_label_string(n: String):
	$Label2.text = n
func _process(delta: float) -> void:
	$Label.text = str(Game.player_stats.money)
