extends Control


func set_coin_amount(n: int):
	$Label.text = str(n)

func set_level_label(n: int):
	$Label2.text = "STAGE " + str(n)
	print("setting label")
