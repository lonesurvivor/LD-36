extends Control

onready var global = get_node("/root/global")
onready var parent = get_node("..")

func _ready():
	set_process_input(true)
	pass

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.is_action_pressed("click")):
			var di = global.get_drag_item()
			if(di != null):
				if(di.get_node("item").is_placeable):
					if(!parent.get_node("blocks").has_node(di.get_name())):
						parent.get_node("blocks").add_child(di)
						#print(get_local_mouse_pos())
						di.set_pos(get_local_mouse_pos())

						global.remove_item(di)
						global.set_drag_item(null)