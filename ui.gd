extends CanvasLayer

func update():
	get_node("inventory").update_inventory()


func _on_sound_pressed():
	get_node("/root/global").enable_sound(!get_node("sound").is_pressed())
