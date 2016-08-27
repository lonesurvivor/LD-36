extends CanvasLayer
#
#onready var global = get_node("/root/global")
#var first = true
#
#var button_to_item = {}
#
#var drag_texture = null
#
#func _ready():
#	if(first):
#		for i in get_node("inventory").get_children():
#			i.connect("input_event", self, "_on_click", [i.get_name()])
#		first = false
#	
#	update()
#	
#	set_process(true)
#	
#func _draw():
#	if(drag_texture != null):
#		var mp = get_viewport().get_mouse_position()
#		draw_texture(drag_texture,mp)
#	print(drag_texture)
#		
#		
func update():
	get_node("inventory").update_inventory()
#		
#		
#		
#func _on_click(ev, button):
#	if(ev.is_action_pressed("click")):
#		if(button_to_item.has(button)):
#			var f = Texture
#			f = global.get_items()[button_to_item[button]].get_node("item").inventory_texture
#			drag_texture = f
#			print(drag_texture)