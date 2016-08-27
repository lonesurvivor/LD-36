extends Control

onready var parent = get_node("..")
onready var global = get_node("/root/global")
var first = true

var button_to_item = {}

func _ready():
	if(first):
		for i in get_children():
			i.connect("input_event", self, "_on_click", [i.get_name()])
		first = false
	
	update()	
	set_process(true)
	
func _process(delta):
	update()
	
func _draw():
	if(global.get_drag_item() != null):
		var mp = get_viewport().get_mouse_pos()
		draw_texture(global.get_drag_item().get_node("item").inventory_texture, Vector2(mp.x / parent.get_scale().x, mp.y / parent.get_scale().y))

		
func update_inventory():
	var items = global.get_items()
	for i in get_children():
		i.get_node("icon").set_texture(null)
	button_to_item = {}
	
	var pos = 0
	for i in items:
		var node = get_node(str(pos) + "/icon")
		node.set_texture(items[i].get_node("item").inventory_texture)
		button_to_item[str(pos)] = i
		pos += 1
		
		
		
func _on_click(ev, button):
	var di = global.get_drag_item()
	if(button_to_item.has(button) and ev.type == InputEvent.MOUSE_BUTTON):
		var i = global.get_items()[button_to_item[button]]
		if(ev.is_action_pressed("click")):
			if(di == null):
				global.set_drag_item(i)
			else:
				if(di == i):
					global.set_drag_item(null)	
				else:
					i.get_node("interactable").interact_with(di)
		elif(ev.is_action_pressed("right_click") ):
			if(di == null):
				i.get_node("item").inspect_in_inventory()