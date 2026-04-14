extends Node2D
var current_top = 0
@onready var chamber_bullets = [$Chamber2/sprite, $Chamber2/sprite2, $Chamber2/sprite3, $Chamber2/sprite4, $Chamber2/sprite5, $Chamber2/sprite6]
func spin():
	chamber_bullets[current_top].visible = false
	#if current_top>0:
		#chamber_bullets[current_top-1].visible = true
	#else:
		#chamber_bullets[5].visible = true
	current_top +=1
	current_top = current_top%6
	for n in 30:
		$Chamber2.rotation_degrees -= 2
		await get_tree().create_timer(0.01).timeout
func load_bullets(bullet_array):
	$Chamber2.rotation_degrees = 2
	
	for i in 6:
		# Check if this index actually exists in the incoming array
		if i < bullet_array.size():
			chamber_bullets[i].visible = true
			
			match bullet_array[i]:
				1:
					chamber_bullets[i].play("basic")
				2:
					chamber_bullets[i].play("light")
				3:
					chamber_bullets[i].play("heavy")
				4:
					chamber_bullets[i].play("icy")
				5:
					chamber_bullets[i].play("shock")
				6:
					chamber_bullets[i].play("nano")
				0:
					chamber_bullets[i].play("blank")
		else:
			# If the array is smaller than 6, make the remaining slots blank or invisible
			chamber_bullets[i].play("blank") 
			# Or use: chamber_bullets[i].visible = false
